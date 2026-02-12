# Helper for CUDA runtime path setup.
# Standardizes LD_LIBRARY_PATH, TRITON, and XLA configuration
# for packages using NVIDIA Python wheels.
#
# Usage in a package wrapper:
#   let cudaEnv = mkCudaEnv { pythonEnv = python-with-alphafold3; };
#   in makeWrapper ... ${lib.concatStringsSep " " cudaEnv.wrapperArgs}
#
# Usage in devShell:
#   shellHook = (mkCudaEnv { pythonEnv = myPython; }).shellHook;
{ lib, pkgs }:

{
  pythonEnv,
  modules ? [
    "cuda_runtime"
    "cublas"
    "cudnn"
    "cusparse"
    "cusolver"
    "cufft"
    "cuda_cupti"
    "nccl"
    "nvjitlink"
  ],
}:

let
  sitePackages = pythonEnv.sitePackages or "${pythonEnv.python.sitePackages}";
  cudaLibsPath = lib.concatMapStringsSep ":" (
    name: "${pythonEnv}/${sitePackages}/nvidia/${name}/lib"
  ) modules;
  driverPath = "${pkgs.addDriverRunpath.driverLink}/lib";
  ptxasPath = "${pkgs.cudaPackages.cuda_nvcc}/bin/ptxas";
  cudaDataDir = "${pkgs.cudaPackages.cuda_nvcc}";
in
{
  inherit cudaLibsPath;

  wrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${driverPath}:${cudaLibsPath}"
    "--set TRITON_PTXAS_PATH ${ptxasPath}"
    "--set XLA_FLAGS --xla_gpu_cuda_data_dir=${cudaDataDir}"
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="${driverPath}:${cudaLibsPath}:''${LD_LIBRARY_PATH:-}"
    export TRITON_PTXAS_PATH="${ptxasPath}"
    export XLA_FLAGS="''${XLA_FLAGS:+$XLA_FLAGS }--xla_gpu_cuda_data_dir=${cudaDataDir}"
  '';
}

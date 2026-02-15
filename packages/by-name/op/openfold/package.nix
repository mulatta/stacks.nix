{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  ninja,
  torch,
  # dependencies
  biopython,
  deepspeed,
  dm-tree,
  dllogger,
  flash-attn,
  ml-collections,
  modelcif,
  numpy,
  openmm,
  pandas,
  pdbfixer,
  pytorch-lightning,
  pyyaml,
  requests,
  scipy,
  tqdm,
  wandb,
}:
let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  inherit (cudaPackages) backendStdenv;
in
buildPythonPackage {
  pname = "openfold";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aqlaboratory";
    repo = "openfold";
    tag = "v2.2.0";
    hash = "sha256-LXAFTfl32L22zE2iXVw5D6xBpmP366/5UjDIxKeeTtE=";
  };

  # Upstream only targets Python 3.10. On 3.12+ `import importlib` no
  # longer implicitly loads the `util` submodule, breaking every
  # `importlib.util.find_spec()` call in the codebase.
  postPatch = ''
        substituteInPlace \
          openfold/config.py \
          openfold/model/primitives.py \
          openfold/utils/checkpointing.py \
          tests/compare_utils.py \
          --replace-fail 'import importlib' \
            'import importlib
    import importlib.util'
  '';

  env = {
    CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" cudaCapabilities}";
    CC = "${backendStdenv.cc}/bin/cc";
    CXX = "${backendStdenv.cc}/bin/c++";
  };

  build-system = [
    setuptools
    ninja
    torch
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_cccl
    cudaPackages.libcusparse # cusparse.h (torch ATen headers)
    cudaPackages.libcublas
    cudaPackages.libcusolver
    cudaPackages.libcurand
  ];

  dependencies = [
    biopython
    deepspeed
    dm-tree
    dllogger
    flash-attn
    ml-collections
    modelcif
    numpy
    openmm
    pandas
    pdbfixer
    pytorch-lightning
    pyyaml
    requests
    scipy
    torch
    tqdm
    wandb
  ];

  # Tests require CUDA GPU
  doCheck = false;

  pythonImportsCheck = [ "openfold" ];

  meta = {
    broken = !cudaSupport;
    description = "A PyTorch reimplementation of DeepMind's AlphaFold 2";
    homepage = "https://github.com/aqlaboratory/openfold";
    changelog = "https://github.com/aqlaboratory/openfold/releases/tag/v2.2.0";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}

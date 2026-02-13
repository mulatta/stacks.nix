{
  lib,
  buildPythonPackage,
  fetchPypi,
  autoPatchelfHook,
  stdenv,
  torch,
  tqdm,
  nvidia-ml-py,
  platformdirs,
}:
buildPythonPackage (
  finalAttrs:
  let
    inherit (torch) cudaPackages cudaSupport;

    wheels = {
      x86_64-linux = {
        platform = "manylinux_2_24_x86_64.manylinux_2_28_x86_64";
        hash = "sha256-e731gCdI2/7N8B3IhqQGhA7tgSlvg+EZIipeyZQh+Rc=";
      };
      aarch64-linux = {
        platform = "manylinux_2_24_aarch64.manylinux_2_28_aarch64";
        hash = "sha256-QYtZPHpDhJwwCYihmoIC5Sym1HJxvxYDzOtvOrXkqlo=";
      };
    };
    wheel =
      wheels.${stdenv.hostPlatform.system}
        or (throw "cuequivariance-ops-cu12 ${finalAttrs.version}: no wheel for ${stdenv.hostPlatform.system}");
  in
  {
    pname = "cuequivariance-ops-cu12";
    version = "0.8.1";
    format = "wheel";

    src = fetchPypi {
      pname = "cuequivariance_ops_cu12";
      inherit (finalAttrs) version;
      format = "wheel";
      dist = "py3";
      python = "py3";
      abi = "none";
      inherit (wheel) platform hash;
    };

    nativeBuildInputs = [ autoPatchelfHook ];

    # Link against cudaPackages instead of nvidia-cublas-cu12 Python wheel
    buildInputs = [ cudaPackages.libcublas ];

    dependencies = [
      tqdm
      nvidia-ml-py
      platformdirs
    ];

    doCheck = false;
    pythonImportsCheck = [ "cuequivariance_ops_cu12" ];

    meta = {
      broken = !cudaSupport;
      description = "NVIDIA cuEquivariance CUDA 12 operations";
      homepage = "https://github.com/NVIDIA/cuEquivariance";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
    };
  }
)

{
  lib,
  buildPythonPackage,
  fetchPypi,
  autoPatchelfHook,
  stdenv,
  python,
  torch,
  cuequivariance-ops-cu12,
  scipy,
}:
buildPythonPackage (
  finalAttrs:
  let
    pyTag = "cp${lib.replaceStrings [ "." ] [ "" ] python.pythonVersion}";

    wheels = {
      "cp311-x86_64-linux" = {
        platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
        hash = "sha256-kIz2fLiRtSPBpSwgLKkRF+ujgteSce43ekrZNzvrh2I=";
      };
      "cp311-aarch64-linux" = {
        platform = "manylinux_2_26_aarch64.manylinux_2_28_aarch64";
        hash = "sha256-IkFu+zgiEhO9SuHDsWEXmNRDDRdCVPPJN917PjqyLeI=";
      };
      "cp312-x86_64-linux" = {
        platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
        hash = "sha256-g5omLGu0YWhOfZKfW/S5bC+lilMI5kwhPseDX7HDkH4=";
      };
      "cp312-aarch64-linux" = {
        platform = "manylinux_2_26_aarch64.manylinux_2_28_aarch64";
        hash = "sha256-R3DE5zDNGauqHpsuGIRbJfzLLfChldEy0B5CiYCATPI=";
      };
      "cp313-x86_64-linux" = {
        platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
        hash = "sha256-6EKiamG0W9NydtDaZYytuU/smAJ59VELFHI/G8HRysk=";
      };
      "cp313-aarch64-linux" = {
        platform = "manylinux_2_26_aarch64.manylinux_2_28_aarch64";
        hash = "sha256-Xm7IuX0yi+3DT994MKwJcpUeyxjhgXn2dcv4EOFdcvM=";
      };
    };

    wheelKey = "${pyTag}-${stdenv.hostPlatform.system}";
    wheel =
      wheels.${wheelKey}
        or (throw "cuequivariance-ops-torch-cu12 ${finalAttrs.version}: no wheel for ${wheelKey}");
  in
  {
    pname = "cuequivariance-ops-torch-cu12";
    version = "0.8.1";
    format = "wheel";

    src = fetchPypi {
      pname = "cuequivariance_ops_torch_cu12";
      inherit (finalAttrs) version;
      format = "wheel";
      python = pyTag;
      dist = pyTag;
      abi = pyTag;
      inherit (wheel) platform hash;
    };

    nativeBuildInputs = [ autoPatchelfHook ];

    dependencies = [
      cuequivariance-ops-cu12
      scipy
    ];

    pythonImportsCheck = [ "cuequivariance_ops_torch_cu12" ];
    doCheck = false;

    meta = {
      broken = !torch.cudaSupport;
      description = "PyTorch CUDA 12 operations for NVIDIA cuEquivariance";
      homepage = "https://github.com/NVIDIA/cuEquivariance";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
    };
  }
)

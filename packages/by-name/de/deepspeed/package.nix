{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  einops,
  hjson,
  msgpack,
  ninja,
  numpy,
  packaging,
  psutil,
  py-cpuinfo,
  pydantic,
  torch,
  tqdm,
}:
buildPythonPackage {
  pname = "deepspeed";
  version = "0.18.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepspeedai";
    repo = "DeepSpeed";
    tag = "v0.18.6";
    hash = "sha256-SejkO1kGDaYLyz8TSLWD8HuQ4+9EkQ5gBkYdvgjolnU=";
  };

  build-system = [ setuptools ];

  # Prevent CUDA ops from being compiled at build time.
  # They will be JIT-compiled at runtime when needed.
  env.DS_BUILD_OPS = "0";

  # Pin version string so setup.py doesn't try to run git
  postPatch = ''
    echo '0.18.6' > build.txt
  '';

  dependencies = [
    einops
    hjson
    msgpack
    ninja
    numpy
    packaging
    psutil
    py-cpuinfo
    pydantic
    setuptools # distutils (used by JIT op builder at runtime)
    torch
    tqdm
  ];

  # Tests require GPUs and a full distributed setup
  doCheck = false;

  # import deepspeed triggers op_builder chain which needs distutils/CUDA
  pythonImportsCheck = [ ];

  meta = {
    description = "DeepSpeed: a deep learning optimization library";
    homepage = "https://github.com/deepspeedai/DeepSpeed";
    changelog = "https://github.com/deepspeedai/DeepSpeed/releases/tag/v0.18.6";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}

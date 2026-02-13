{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  cmake,
  pybind11,
  numpy,
  simsimd,
  tqdm,
  which,
}:

buildPythonPackage (finalAttrs: {
  pname = "usearch";
  version = "2.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unum-cloud";
    repo = "usearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Oz6tMkGBCA5zy1WRuqFTy2VQ1crNAtwn1WM2IyhXW9w=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ which ];

  build-system = [
    setuptools
    wheel
    cmake
    pybind11
    numpy
    simsimd
  ];

  dependencies = [
    numpy
    tqdm
    simsimd
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "usearch" ];

  # Tests require additional setup
  doCheck = false;

  meta = {
    description = "Smaller & Faster Single-File Vector Search Engine";
    homepage = "https://github.com/unum-cloud/usearch";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})

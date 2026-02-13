{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  numpy,
  # dependencies
  pandas,
}:
buildPythonPackage (finalAttrs: {
  pname = "cpdb-protein";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "a-r-j";
    repo = "cpdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ShX16rQ7H1+htt6aIMs8X8rVsN+y9NNSgFLMkRLyAto=";
  };

  build-system = [
    setuptools
    cython
    numpy
  ];

  dependencies = [
    numpy
    pandas
  ];

  pythonImportsCheck = [ "cpdb" ];

  doCheck = false;

  meta = {
    description = "Cython-accelerated protein data bank parser";
    homepage = "https://github.com/a-r-j/cpdb";
    license = lib.licenses.mit;
  };
})

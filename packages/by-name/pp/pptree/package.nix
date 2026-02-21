{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "pptree";
  version = "3.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-TdC6L1gADL0p1opbZLrCm8taZjZC95QEh3wAWWaKafY=";
  };

  build-system = [ setuptools ];

  # no test suite
  doCheck = false;

  pythonImportsCheck = [ "pptree" ];

  meta = {
    description = "Pretty-print trees in Python";
    homepage = "https://github.com/clemtoy/pptree";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "pyqtree";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "Pyqtree";
    inherit (finalAttrs) version;
    hash = "sha256-TzbVFg3fFw1yRenHECpFIRuFADOD3VUrbNEJ5QzDr4E=";
  };

  build-system = [ setuptools ];

  # no tests included in sdist
  doCheck = false;

  pythonImportsCheck = [ "pyqtree" ];

  meta = {
    description = "Pure Python quad tree spatial index";
    homepage = "https://github.com/karimbahgat/Pyqtree";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

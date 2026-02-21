{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
}:
buildPythonPackage (finalAttrs: {
  pname = "conllu";
  version = "4.5.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-oBbPd+IDsuOs6C/PDLoodFMNFFjodFIWQOujbhlUasw=";
  };

  build-system = [ setuptools ];

  # tests require fixtures not included in sdist
  doCheck = false;

  pythonImportsCheck = [ "conllu" ];

  meta = {
    description = "CoNLL-U file parser";
    homepage = "https://github.com/EmilStenstrom/conllu";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lxml,
  jsonlines,
  intervaltree,
  tqdm,
  docopt,
  pythonOlder,
}:
buildPythonPackage (finalAttrs: {
  pname = "bioc";
  version = "2.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-fZJIGYva4pGw67IY3i3GU8ltMqfqwvoO9O0MdM5Fqqo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    jsonlines
    intervaltree
    tqdm
    docopt
  ];

  # tests require fixtures not included in sdist
  doCheck = false;

  pythonImportsCheck = [ "bioc" ];

  meta = {
    description = "Data structures and utilities for BioC format";
    homepage = "https://github.com/bionlplab/bioc";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

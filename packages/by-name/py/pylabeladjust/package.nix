{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pyqtree,
  tqdm,
  pandas,
  matplotlib,
  pythonOlder,
}:
buildPythonPackage (finalAttrs: {
  pname = "pylabeladjust";
  version = "0.1.13";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-I8H5+AlsXH3p+nlnjOcpyjcwuI2XmZf6JOmcA3pI9Zs=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pyqtree
    tqdm
    pandas
    matplotlib
  ];

  # no test suite in sdist
  doCheck = false;

  pythonImportsCheck = [ "pylabeladjust" ];

  meta = {
    description = "Label adjustment for matplotlib scatter plots";
    homepage = "https://github.com/MNoichl/pylabeladjust";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
})

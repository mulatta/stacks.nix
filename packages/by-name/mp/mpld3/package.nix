{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  jinja2,
  matplotlib,
}:
buildPythonPackage (finalAttrs: {
  pname = "mpld3";
  version = "0.5.12";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-EzPivKAS6przwngBujb2W8JlQLb61MVqkDr7GUd/LDc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    matplotlib
  ];

  # tests require browser/JS infrastructure
  doCheck = false;

  pythonImportsCheck = [ "mpld3" ];

  meta = {
    description = "D3 viewer for matplotlib";
    homepage = "https://github.com/jakevdp/mpld3";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})

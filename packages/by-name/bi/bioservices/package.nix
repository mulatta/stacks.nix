{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  # dependencies
  appdirs,
  beautifulsoup4,
  click,
  colorlog,
  easydev,
  grequests,
  lxml,
  matplotlib,
  pandas,
  requests,
  requests-cache,
  rich-click,
  suds-community,
  tqdm,
  wrapt,
  xmltodict,
}:
buildPythonPackage (finalAttrs: {
  pname = "bioservices";
  version = "1.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cokelaer";
    repo = "bioservices";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SRujv4/3e9cYRErrmH4zGwRMEi6TxygC/HhsiHQnzIw=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "lxml"
    "xmltodict"
  ];

  dependencies = [
    appdirs
    beautifulsoup4
    click
    colorlog
    easydev
    grequests
    lxml
    matplotlib
    pandas
    requests
    requests-cache
    rich-click
    suds-community
    tqdm
    wrapt
    xmltodict
  ];

  pythonImportsCheck = [ "bioservices" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Access to biological web services programmatically";
    homepage = "https://github.com/cokelaer/bioservices";
    license = lib.licenses.gpl3Only;
  };
})

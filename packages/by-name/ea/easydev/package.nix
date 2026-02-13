{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  # dependencies
  colorama,
  colorlog,
  line-profiler,
  pexpect,
  platformdirs,
}:
buildPythonPackage (finalAttrs: {
  pname = "easydev";
  version = "0.13.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cokelaer";
    repo = "easydev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zr+fJBAoot3XIh4i/5Ng3G7Tku5mdLdqpaL5tQDcOiY=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "line-profiler"
  ];

  dependencies = [
    colorama
    colorlog
    line-profiler
    pexpect
    platformdirs
  ];

  pythonImportsCheck = [ "easydev" ];

  doCheck = false;

  meta = {
    description = "Common utilities to ease Python package development";
    homepage = "https://github.com/cokelaer/easydev";
    license = lib.licenses.bsd3;
  };
})

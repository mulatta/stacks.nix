{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  httpx,
  nest-asyncio,
  tenacity,
  # optional-dependencies
  mcp,
  # tests
  pytestCheckHook,
  vcrpy,
}:
buildPythonPackage (finalAttrs: {
  pname = "semanticscholar";
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mulatta";
    repo = "semanticscholar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h5cIKuF+1s2MlmZ90d7Ch5YKvc/9nmyh4T/lSa3ADf8=";
  };

  # Remove nix/ directory so setuptools auto-discovery
  # doesn't treat it as a top-level Python package
  postPatch = ''
    rm -rf nix
  '';

  build-system = [ setuptools ];

  dependencies = [
    httpx
    nest-asyncio
    tenacity
  ];

  optional-dependencies = {
    mcp = [ mcp ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [ "semanticscholar" ];

  meta = {
    description = "Unofficial Python client library for Semantic Scholar APIs";
    homepage = "https://github.com/mulatta/semanticscholar";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

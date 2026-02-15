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
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mulatta";
    repo = "semanticscholar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n5BRoFii1ZEqkec9yMY4iNEJPeGF7OqT158X+1s/ToI=";
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

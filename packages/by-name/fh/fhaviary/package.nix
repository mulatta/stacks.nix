{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  docstring-parser,
  httpx,
  httpx-aiohttp,
  pydantic,
  fhlmi,
  litellm,
  packaging,
  pillow,
}:

buildPythonPackage (finalAttrs: {
  pname = "fhaviary";
  version = "0.32.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Future-House";
    repo = "aviary";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CRL/JrPwsAxDP+1XpO56cBc5nqIyHZX9BYfv6pMq1sQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    docstring-parser
    httpx
    httpx-aiohttp
    pydantic
  ];

  optional-dependencies = {
    image = [ pillow ];
    llm = [
      fhlmi
      litellm
      packaging
    ];
  };

  pythonImportsCheck = [ "aviary" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Gymnasium framework for training language model agents on constructive tasks";
    homepage = "https://github.com/Future-House/aviary";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})

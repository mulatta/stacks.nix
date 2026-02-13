{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  aiofiles,
  fhaviary,
  fhlmi,
  httpx-aiohttp,
  numpy,
  pydantic,
  tenacity,
  tiktoken,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "ldp";
  version = "0.43.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-FdRrBSvfDgPELv60e6AfFl0j+PsPzNzw3FvGV4qDVls=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiofiles
    fhaviary
    fhlmi
    httpx-aiohttp
    numpy
    pydantic
    tenacity
    tiktoken
    tqdm
  ];

  pythonImportsCheck = [ "ldp" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Agent framework for constructing language model agents";
    homepage = "https://github.com/Future-House/ldp";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})

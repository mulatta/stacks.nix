{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  # dependencies
  absl-py,
  aiohttp,
  async-timeout,
  exceptiongroup,
  google-genai,
  google-cloud-storage,
  ml-collections,
  more-itertools,
  numpy,
  pandas,
  pydantic,
  python-dotenv,
  pyyaml,
  regex,
  requests,
  tqdm,
  typing-extensions,
  # optional
  openai,
}:

buildPythonPackage (finalAttrs: {
  pname = "langextract";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-b4BCO73iDs7ZCK/KsgR50sU6+pYBRa0LvXIglWfPaWE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    absl-py
    aiohttp
    async-timeout
    exceptiongroup
    google-genai
    google-cloud-storage
    ml-collections
    more-itertools
    numpy
    pandas
    pydantic
    python-dotenv
    pyyaml
    regex
    requests
    tqdm
    typing-extensions
  ];

  optional-dependencies = {
    openai = [ openai ];
  };

  pythonImportsCheck = [ "langextract" ];

  # Tests require live API access
  doCheck = false;

  meta = {
    description = "A library for extracting structured data from language models";
    homepage = "https://github.com/google/langextract";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mulatta ];
    platforms = lib.platforms.unix;
  };
})

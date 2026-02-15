{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build system
  hatchling,
  # frontend assets
  embedding-atlas-frontend,
  # dependencies
  click,
  pandas,
  fastparquet,
  platformdirs,
  umap-learn,
  sentence-transformers,
  fastapi,
  uvicorn,
  uvloop,
  pyarrow,
  duckdb,
  inquirer,
  llvmlite,
  accelerate,
  tqdm,
  litellm,
  websockets,
  # optional-dependencies
  datasets,
}:

buildPythonPackage (finalAttrs: {
  pname = "embedding-atlas";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apple";
    repo = "embedding-atlas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ue+aq9FFAFqetD7upLGFFlDsDSNLv7hY2LMbRXbpTtA=";
  };

  sourceRoot = "source/packages/backend";

  build-system = [ hatchling ];

  postPatch = ''
    # Inject pre-built frontend assets
    rm -rf embedding_atlas/static embedding_atlas/widget_static
    cp -r ${embedding-atlas-frontend}/viewer-dist embedding_atlas/static
    cp -r ${embedding-atlas-frontend}/widget_static embedding_atlas/widget_static
  '';

  dependencies = [
    click
    pandas
    fastparquet
    platformdirs
    umap-learn
    sentence-transformers
    fastapi
    uvicorn
    uvloop
    pyarrow
    duckdb
    inquirer
    llvmlite
    accelerate
    tqdm
    litellm
    websockets
  ];

  optional-dependencies = {
    hf = [ datasets ];
  };

  passthru = {
    frontend = embedding-atlas-frontend;
  };

  pythonImportsCheck = [ "embedding_atlas" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "A tool for visualizing embeddings";
    homepage = "https://apple.github.io/embedding-atlas";
    changelog = "https://github.com/apple/embedding-atlas/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mulatta ];
    mainProgram = "embedding-atlas";
    # pynndescent (via umap-learn) not available on aarch64-linux
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})

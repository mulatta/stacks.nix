{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  # core dependencies
  hdbscan,
  umap-learn,
  numpy,
  pandas,
  plotly,
  scikit-learn,
  sentence-transformers,
  tqdm,
  # optional: datamap
  datamapplot,
  matplotlib,
  # optional: flair
  flair,
  torch,
  transformers,
  # optional: fastembed
  fastembed,
  # optional: gensim
  gensim,
  # optional: spacy
  spacy,
  # optional: use
  tensorflow,
  tensorflow-hub,
  tensorflow-text,
  # optional: vision
  accelerate,
  pillow,
  pythonOlder,
}:
buildPythonPackage (finalAttrs: {
  pname = "bertopic";
  version = "0.17.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+SqlYM3yvL+eIsjug907+yJbjcKTgd7HMnzAshvYUq0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    hdbscan
    umap-learn
    numpy
    pandas
    plotly
    scikit-learn
    sentence-transformers
    tqdm
  ];

  optional-dependencies = {
    datamap = [
      datamapplot
      matplotlib
    ];
    flair = [
      flair
      torch
      transformers
    ];
    fastembed = [ fastembed ];
    gensim = [ gensim ];
    spacy = [ spacy ];
    use = [
      tensorflow
      tensorflow-hub
      tensorflow-text
    ];
    vision = [
      accelerate
      pillow
    ];
  };

  # tests require model downloads
  doCheck = false;

  # numba @vectorize(cache=True) in pynndescent tries to cache in read-only nix store;
  # NUMBA_DISABLE_JIT only affects @jit, so redirect cache dir instead
  postFixup = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)
  '';

  pythonImportsCheck = [ "bertopic" ];

  meta = {
    description = "Leveraging BERT and a class-based TF-IDF to create easily interpretable topics";
    homepage = "https://github.com/MaartenGr/BERTopic";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  # dependencies
  boto3,
  conllu,
  deprecated,
  ftfy,
  gdown,
  huggingface-hub,
  langdetect,
  lxml,
  matplotlib,
  more-itertools,
  mpld3,
  pptree,
  python-dateutil,
  pytorch-revgrad,
  regex,
  scikit-learn,
  segtok,
  sqlitedict,
  tabulate,
  torch,
  tqdm,
  transformer-smaller-training-vocab,
  transformers,
  sentencepiece,
  wikipedia-api,
  bioc,
  # optional
  gensim,
  bpemb,
  pythonOlder,
}:
buildPythonPackage (finalAttrs: {
  pname = "flair";
  version = "0.15.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-eAtO7/ugRMShgfGBCHL8ASAcLq7Y0u9LyxJqZGTpGTM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    boto3
    conllu
    deprecated
    ftfy
    gdown
    huggingface-hub
    langdetect
    lxml
    matplotlib
    more-itertools
    mpld3
    pptree
    python-dateutil
    pytorch-revgrad
    regex
    scikit-learn
    segtok
    sqlitedict
    tabulate
    torch
    tqdm
    transformer-smaller-training-vocab
    transformers
    sentencepiece
    wikipedia-api
    bioc
  ];

  optional-dependencies = {
    word-embeddings = [
      gensim
      bpemb
    ];
  };

  # tests require model downloads and GPU
  doCheck = false;

  pythonImportsCheck = [ "flair" ];

  meta = {
    description = "A very simple framework for state-of-the-art NLP";
    homepage = "https://github.com/flairNLP/flair";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

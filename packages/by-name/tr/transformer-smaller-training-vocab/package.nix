{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  transformers,
  sentencepiece,
  torch,
  pythonOlder,
}:
buildPythonPackage (finalAttrs: {
  pname = "transformer-smaller-training-vocab";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "transformer_smaller_training_vocab";
    inherit (finalAttrs) version;
    hash = "sha256-rtQ5AzHmPZoJmNdvJ3t9RK1dOLhCetd5Kx4oyAeAHtg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    transformers
    sentencepiece
    torch
  ];

  # tests require model downloads
  doCheck = false;

  pythonImportsCheck = [ "transformer_smaller_training_vocab" ];

  meta = {
    description = "Reduce training vocabulary of transformers for faster training";
    homepage = "https://github.com/helpmefindaname/transformer-smaller-training-vocab";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

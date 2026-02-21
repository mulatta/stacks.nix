{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  protobuf,
}:
buildPythonPackage (finalAttrs: {
  pname = "tensorflow-hub";
  version = "0.16.1";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_hub";
    inherit (finalAttrs) version;
    format = "wheel";
    dist = "py2.py3";
    python = "py2.py3";
    abi = "none";
    platform = "any";
    hash = "sha256-4QwYSz0I2ur62hH/6i3UZ4FyW2vvAfrR901mNK0FMR8=";
  };

  # tf-keras not in nixpkgs; users provide it via tensorflow
  pythonRemoveDeps = [ "tf-keras" ];

  dependencies = [
    numpy
    protobuf
  ];

  # requires tensorflow runtime
  doCheck = false;

  # tensorflow_hub.__init__ calls _ensure_tf_install() which requires tensorflow
  # pythonImportsCheck = [ "tensorflow_hub" ];

  meta = {
    description = "TensorFlow Hub is a library for reusable machine learning modules";
    homepage = "https://github.com/tensorflow/hub";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})

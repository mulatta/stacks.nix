{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit,
  torch,
  pythonOlder,
}:
buildPythonPackage (finalAttrs: {
  pname = "pytorch-revgrad";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "pytorch_revgrad";
    inherit (finalAttrs) version;
    hash = "sha256-nPCXp9GMut3ersn+90sljXC2y40Md/UkuqsYv/x9e+k=";
  };

  build-system = [ flit ];

  dependencies = [ torch ];

  # tests require GPU
  doCheck = false;

  pythonImportsCheck = [ "pytorch_revgrad" ];

  meta = {
    description = "Gradient reversal layer for PyTorch";
    homepage = "https://github.com/janfreyberg/pytorch-revgrad";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

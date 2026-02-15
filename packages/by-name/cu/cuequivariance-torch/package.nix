{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  cuequivariance,
  torch,
}:
buildPythonPackage (finalAttrs: {
  pname = "cuequivariance-torch";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    pname = "cuequivariance_torch";
    inherit (finalAttrs) version;
    hash = "sha256-A6kkt6TFe+2Hyj0DRSGOuAXY0uhI9fXFcZKi5Kjrw9s=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cuequivariance
    torch
  ];

  # Tests require GPU
  doCheck = false;

  pythonImportsCheck = [ "cuequivariance_torch" ];

  meta = {
    description = "PyTorch bindings for NVIDIA cuEquivariance";
    homepage = "https://github.com/NVIDIA/cuEquivariance";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})

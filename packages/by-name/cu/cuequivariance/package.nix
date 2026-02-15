{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  networkx,
  numpy,
  opt-einsum,
  scipy,
  sympy,
}:
buildPythonPackage (finalAttrs: {
  pname = "cuequivariance";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-85jdC2H4CJSZTvEqasfdhE49MBpUhrmf8X0AgvHiK0w=";
  };

  build-system = [ hatchling ];

  dependencies = [
    networkx
    numpy
    opt-einsum
    scipy
    sympy
  ];

  # Tests require GPU
  doCheck = false;

  pythonImportsCheck = [ "cuequivariance" ];

  meta = {
    description = "NVIDIA cuEquivariance library for equivariant neural networks";
    homepage = "https://github.com/NVIDIA/cuEquivariance";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})

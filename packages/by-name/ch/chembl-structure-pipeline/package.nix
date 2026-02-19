{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  rdkit,
}:
buildPythonPackage (finalAttrs: {
  pname = "chembl-structure-pipeline";
  version = "1.2.2";
  pyproject = true;

  src = fetchPypi {
    pname = "chembl_structure_pipeline";
    inherit (finalAttrs) version;
    hash = "sha256-Yl/8JfhtfW/htFmjgbKlL7HfX+DIu/6cYV6Lf3XDAcg=";
  };

  build-system = [ setuptools ];

  dependencies = [ rdkit ];

  # nixpkgs rdkit is CMake-built (no Python dist-info metadata),
  # so pythonRuntimeDepsCheck can't find it via importlib.metadata
  pythonRemoveDeps = [ "rdkit" ];

  # Tests require ChEMBL database access
  doCheck = false;

  pythonImportsCheck = [ "chembl_structure_pipeline" ];

  meta = {
    description = "ChEMBL protocols used to standardise and salt strip molecules";
    homepage = "https://www.ebi.ac.uk/chembl/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

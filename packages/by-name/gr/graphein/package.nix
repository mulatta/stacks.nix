{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  pandas,
  biopandas,
  biopython,
  bioservices,
  cpdb-protein,
  cython,
  deepdiff,
  loguru,
  looseversion,
  matplotlib,
  multipledispatch,
  networkx,
  numpy,
  plotly,
  pydantic,
  rich,
  rich-click,
  seaborn,
  pyyaml,
  scikit-learn,
  scipy,
  tqdm,
  wget,
  xarray,
  jaxtyping,
  # optional deps
  einops,
  nest-asyncio,
}:
buildPythonPackage (finalAttrs: {
  pname = "graphein";
  version = "1.7.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "a-r-j";
    repo = "graphein";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eJXKWg/V9UOVgKxQimLPhf8p9b2LOHoA9L4dpj3kxDI=";
  };

  patches = [ ./fix-atoms-rdkit-guard.patch ];

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "numpy"
    "cpdb-protein"
  ];

  dependencies = [
    pandas
    biopandas
    biopython
    bioservices
    cpdb-protein
    cython
    deepdiff
    loguru
    looseversion
    matplotlib
    multipledispatch
    networkx
    numpy
    plotly
    pydantic
    rich
    rich-click
    seaborn
    pyyaml
    scikit-learn
    scipy
    tqdm
    wget
    xarray
    jaxtyping
  ];

  optional-dependencies = {
    extras = [
      einops
      nest-asyncio
    ];
  };

  # Tests require network access and external tools (dssp, pymol)
  doCheck = false;

  pythonImportsCheck = [
    "graphein"
    "graphein.protein"
    "graphein.molecule"
    "graphein.rna"
    "graphein.ppi"
  ];

  meta = {
    description = "Protein Graph Library";
    homepage = "https://github.com/a-r-j/graphein";
    changelog = "https://github.com/a-r-j/graphein/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

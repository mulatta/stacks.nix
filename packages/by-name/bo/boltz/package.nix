{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  torch,
  pytorch-lightning,
  hydra-core,
  rdkit,
  biopython,
  scipy,
  scikit-learn,
  pandas,
  einops,
  einx,
  fairscale,
  dm-tree,
  mashumaro,
  modelcif,
  wandb,
  click,
  pyyaml,
  requests,
  types-requests,
  gemmi,
  numba,
  numpy,
  chembl-structure-pipeline,
  # optional-dependencies.cuda
  cuequivariance-ops-cu12,
  cuequivariance-ops-torch-cu12,
  cuequivariance-torch,
}:
buildPythonPackage (finalAttrs: {
  pname = "boltz";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jwohlwend";
    repo = "boltz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cEdt7cO8poGJ8EWoixVaHlRe5SK4cMvdzye9KPLo0Mk=";
  };

  build-system = [ setuptools ];

  # All version pins relaxed — safety verified by source code analysis:
  #
  # numpy (<2.0 → 2.3): no deprecated API usage, all explicit dtype (np.int64 etc.)
  # gemmi (0.6.5 → 0.7): only breaking change is Model.name→num;
  #   boltz uses structure[0] index access, never model.name
  # modelcif (1.2 → 1.6): only System/Assembly/Entity/dumper.write/AbInitioModel used
  # pytorch-lightning (2.5 → 2.6): Trainer/LightningModule/DDPStrategy standard usage
  # scipy (1.13 → 1.16): cdist, linear_sum_assignment, truncnorm — stable APIs
  # scikit-learn (1.6 → 1.7): KDTree + query_radius only
  # numba (0.61 → 0.63): @njit only
  # mashumaro (3.14 → 3.17): DataClassDictMixin only
  # wandb (0.18 → 0.24): not imported in source code
  # click (8.1 → 8.3): @command/@option/@group/is_flag=True standard patterns
  # biopython (1.84 → 1.85): SeqIO.parse, Align.PairwiseAligner core API
  # einops (0.8.0 → 0.8.1): rearrange/einsum (patch version)
  # dm-tree (0.1.8 → 0.1.9): not directly imported (patch version)
  # requests (2.32.3 → 2.32.5): standard usage (patch version)
  # pyyaml (6.0.2 → 6.0.3): standard usage (patch version)
  # chembl-structure-pipeline (1.2.2): exact match
  pythonRelaxDeps = true;

  # rdkit and gemmi are CMake-built in nixpkgs (no Python dist-info metadata),
  # so pythonRuntimeDepsCheck can't find them via importlib.metadata
  pythonRemoveDeps = [
    "rdkit"
    "gemmi"
  ];

  dependencies = [
    torch
    pytorch-lightning
    hydra-core
    rdkit
    biopython
    scipy
    scikit-learn
    pandas
    einops
    einx
    fairscale
    dm-tree
    mashumaro
    modelcif
    wandb
    click
    pyyaml
    requests
    types-requests
    gemmi
    numba
    numpy
    chembl-structure-pipeline
  ];

  # Mirrors upstream [project.optional-dependencies]
  optional-dependencies = {
    cuda = [
      cuequivariance-ops-cu12
      cuequivariance-ops-torch-cu12
      cuequivariance-torch
    ];
  };

  # Tests require network access, model weights, and GPU
  doCheck = false;

  pythonImportsCheck = [ "boltz" ];

  meta = {
    description = "Boltz - biomolecular structure prediction";
    homepage = "https://github.com/jwohlwend/boltz";
    changelog = "https://github.com/jwohlwend/boltz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    # GPU inference requires Linux + CUDA, but CPU mode works on macOS
    platforms = lib.platforms.unix;
  };
})

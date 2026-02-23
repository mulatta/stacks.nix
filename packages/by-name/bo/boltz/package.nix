{
  lib,
  stdenv,
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

  # macOS MPS (Metal) support: upstream hardcodes CUDA device in autocast
  # contexts and CLI options. All autocast("cuda", enabled=False) calls are
  # precision guards (disabling autocast for FP32); "cpu" is universally valid
  # since enabled=False makes device_type a no-op.
  # Ref: https://github.com/jwohlwend/boltz/pull/527
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Pattern 1: torch.autocast("cuda", enabled=False) — 20 occurrences
    substituteInPlace \
      src/boltz/model/layers/attention.py \
      src/boltz/model/layers/attentionv2.py \
      src/boltz/model/layers/pairformer.py \
      src/boltz/model/layers/triangular_attention/primitives.py \
      src/boltz/model/loss/bfactor.py \
      src/boltz/model/loss/confidencev2.py \
      src/boltz/model/loss/distogramv2.py \
      src/boltz/model/models/boltz2.py \
      src/boltz/model/modules/diffusion.py \
      src/boltz/model/modules/diffusionv2.py \
      src/boltz/model/modules/encodersv2.py \
      --replace-fail \
        'torch.autocast("cuda", enabled=False)' \
        'torch.autocast(device_type="cpu", enabled=False)'

    # Pattern 2: torch.autocast(device_type="cuda", enabled=False) — 2 occurrences
    substituteInPlace src/boltz/model/modules/trunkv2.py \
      --replace-fail \
        'torch.autocast(device_type="cuda", enabled=False)' \
        'torch.autocast(device_type="cpu", enabled=False)'

    # Pattern 3: deprecated torch.cuda.amp.autocast — 3 occurrences
    substituteInPlace src/boltz/model/loss/confidencev2.py \
      --replace-fail \
        'torch.cuda.amp.autocast(enabled=False)' \
        'torch.amp.autocast(device_type="cpu", enabled=False)'

    # Add "mps" to --accelerator CLI choices
    substituteInPlace src/boltz/main.py \
      --replace-fail \
        'type=click.Choice(["gpu", "cpu", "tpu"])' \
        'type=click.Choice(["gpu", "cpu", "tpu", "mps"])'

    # Force FP32 on MPS — bf16-mixed is unstable on Metal backend
    substituteInPlace src/boltz/main.py \
      --replace-fail \
        'precision=32 if model == "boltz1" else "bf16-mixed",' \
        'precision=32 if (model == "boltz1" or accelerator == "mps") else "bf16-mixed",'
  '';

  # MPS fallback: some ops (e.g. linalg_svd) lack Metal kernels and need CPU fallback
  makeWrapperArgs = lib.optionals stdenv.hostPlatform.isDarwin [
    "--set"
    "PYTORCH_ENABLE_MPS_FALLBACK"
    "1"
  ];

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
    # Linux: CUDA GPU acceleration; macOS: MPS (Metal) or CPU inference
    platforms = lib.platforms.unix;
  };
})

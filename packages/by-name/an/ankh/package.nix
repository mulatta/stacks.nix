{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  poetry-core,
  # dependencies
  biopython,
  datasets,
  sentencepiece,
  torch,
  transformers,
}:
buildPythonPackage (finalAttrs: {
  pname = "ankh";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agemagician";
    repo = "Ankh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TxL2Z6HoxkYe3osMqPVyFw8rbvXZwpvW0I8Ix03NMu0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    biopython
    datasets
    sentencepiece
    # torch is not declared in pyproject.toml but imported directly in source
    torch
    transformers
  ];

  # macOS MPS support: get_device() only checks CUDA, falling back to CPU.
  # Replace CPU fallback with MPS-aware ternary so Apple Silicon GPU is used.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/ankh/extract.py \
      --replace-fail \
        'device = torch.device("cpu")' \
        'device = torch.device("mps") if torch.backends.mps.is_available() and use_gpu else torch.device("cpu")'
  '';

  # poetry caret constraints are too strict for nixpkgs versions
  pythonRelaxDeps = [
    "datasets"
    "sentencepiece"
  ];

  # Tests require model weights and GPU
  doCheck = false;

  pythonImportsCheck = [ "ankh" ];

  meta = {
    description = "Ankh: Optimized Protein Language Model";
    homepage = "https://github.com/agemagician/Ankh";
    changelog = "https://github.com/agemagician/Ankh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc-by-nc-sa-40;
    # macOS MPS patched in extract.py for Apple Silicon GPU
    platforms = lib.platforms.unix;
  };
})

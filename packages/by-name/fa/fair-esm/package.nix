{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  torch,
  # optional-dependencies: inverse-folding
  biotite,
  scipy,
}:
buildPythonPackage (_finalAttrs: {
  pname = "fair-esm";
  version = "2.0.0-unstable-2023-06-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "esm";
    rev = "2b369911bb5b4b0dda914521b9475cad1656b2ac";
    hash = "sha256-p82UipKQYSFEuCiZijzUlInqwXhXrbiZwcNLBUzLXE0=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    # Fix PyTorch 2.6+ compatibility (weights_only default changed to True)
    substituteInPlace esm/pretrained.py \
      --replace-fail 'map_location="cpu"' 'map_location="cpu", weights_only=False'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # macOS MPS support: extract.py only checks CUDA, falling back to CPU.
    # Add MPS detection so Apple Silicon GPU is used automatically.
    substituteInPlace scripts/extract.py \
      --replace-fail \
        'torch.cuda.is_available() and not args.nogpu' \
        '(torch.cuda.is_available() or torch.backends.mps.is_available()) and not args.nogpu' \
      --replace-fail \
        'model = model.cuda()' \
        'model = model.to("mps" if torch.backends.mps.is_available() else "cuda")' \
      --replace-fail \
        'toks = toks.to(device="cuda", non_blocking=True)' \
        'toks = toks.to(device="mps" if torch.backends.mps.is_available() else "cuda", non_blocking=True)'
  '';

  dependencies = [ torch ];

  optional-dependencies = {
    inverse-folding = [
      biotite
      scipy
    ];
  };

  # Tests require model weights download
  doCheck = false;

  pythonImportsCheck = [ "esm" ];

  meta = {
    description = "Evolutionary Scale Modeling (esm): Pretrained language models for proteins";
    homepage = "https://github.com/facebookresearch/esm";
    changelog = "https://github.com/facebookresearch/esm/releases/tag/v2.0.0";
    license = lib.licenses.mit;
    # Library is device-agnostic; macOS MPS patched in extract.py
    platforms = lib.platforms.unix;
  };
})

# stacks.nix

Detail and rationale: [CONTRIBUTING.md](CONTRIBUTING.md)

## Package Addition

1. `packages/by-name/xx/<name>/package.nix` (xx = first two letters)
2. Python → register in `packages/lib/python-packages.nix`
   non-Python → register in `packages/lib/regular-packages.nix`

## Recipe Rules

- `pyproject = true`, explicit `build-system`
- `pythonImportsCheck` mandatory
- `meta.platforms` mandatory
- `doCheck = false` requires a comment explaining why
- No `rec` — use `stdenv.mkDerivation (finalAttrs: { ... })` pattern
- Do not redefine dependencies already in nixpkgs

## Tiers & Builders

- Same version as nixpkgs → do not define (Tier 1)
- Different version + cheap build → source build (Tier 2)
- Different version + expensive native build → `buildPythonPackage { format = "wheel"; }` (Tier 3)

### Tier 3 wheel pattern

Flat `wheels` attrset keyed by `"${pyTag}-${system}"`, single `fetchPypi` call:

```nix
let
  pyTag = "cp${lib.replaceStrings ["."] [""] python.pythonVersion}";
  wheels = {
    "cp311-x86_64-linux"  = { platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64"; hash = "sha256-..."; };
    "cp312-x86_64-linux"  = { platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64"; hash = "sha256-..."; };
    "cp312-aarch64-linux" = { platform = "manylinux_2_26_aarch64.manylinux_2_28_aarch64"; hash = "sha256-..."; };
  };
  wheelKey = "${pyTag}-${stdenv.hostPlatform.system}";
  wheel = wheels.${wheelKey} or (throw "pkg ${version}: no wheel for ${wheelKey}");
in
buildPythonPackage {
  format = "wheel";
  src = fetchPypi {
    pname = "pkg_name";
    inherit version;
    format = "wheel";
    python = pyTag; dist = pyTag; abi = pyTag;
    inherit (wheel) platform hash;
  };
  # ...
}
```

For py3-none wheels (no Python version dispatch), use `wheels.${stdenv.hostPlatform.system}` with `dist = "py3"; python = "py3"; abi = "none";`.

Examples: `cuequivariance-ops-torch-cu12` (cpXX), `cuequivariance-ops-cu12` (py3-none)

## Overlay

- Layer 1 (`python-packages.nix`): framework-agnostic recipes
- Layer 2 (`frameworks/`): framework version overrides only
- Do not modify `frameworks/` when adding regular packages

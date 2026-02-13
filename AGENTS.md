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
- Different version + expensive native build → wheel via `mkWheelPackage` or `mkNvidiaWheel` (Tier 3)
- Tier 3 packages use `hashes.json` for platform-specific hashes

## Overlay

- Layer 1 (`python-packages.nix`): framework-agnostic recipes
- Layer 2 (`frameworks/`): framework version overrides only
- Do not modify `frameworks/` when adding regular packages

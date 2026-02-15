# Contributing to stacks.nix

Nix package registry for ML, bioinformatics, and scientific computing.

## Repository Structure

```
packages/by-name/xx/<name>/package.nix   # Package recipe (2-letter prefix)
packages/lib/python-packages.nix         # Python package overlay registry
packages/lib/regular-packages.nix        # non-Python package registry
packages/lib/patches/                     # Temporary nixpkgs bug-fix patches
overlays/flake-module.nix                # Overlay composition
```

## Adding a Package

1. Create `packages/by-name/xx/<name>/package.nix`
   - `xx` = first two letters of the package name (e.g. `ankh` → `an/ankh/`)
2. Register the package:
   - Python → add one line to `packages/lib/python-packages.nix`
   - non-Python → add one line to `packages/lib/regular-packages.nix`
3. Verify: `nix build .#<name>`

## Package Tiers

Decide the tier before writing a recipe:

```
Required version == nixpkgs version?
  Yes → Tier 1: use nixpkgs as-is (no recipe needed)
  No  → Expensive native build? (C++/CUDA/Fortran)
          Yes → Tier 3: pre-built wheel
          No  → Tier 2: source build
```

| Tier | Condition | Strategy | Examples |
|------|-----------|----------|----------|
| 1 | Same version as nixpkgs | No definition needed | numpy, scipy |
| 2 | Different version, cheap build | Source build | jax (pure Python), typeguard |
| 3 | Different version, expensive native build | Pre-built wheel | cuequivariance-ops-torch-cu12 |

Tier 3 packages use `buildPythonPackage { format = "wheel"; }` directly with
a `wheelPlatforms` attrset for platform dispatch. See
`packages/by-name/cu/cuequivariance-ops-torch-cu12/package.nix` for the
cpXX (Python-version-specific) pattern and `cuequivariance-ops-cu12/package.nix`
for the py3-none (Python-version-independent) pattern.

## Overlay Model

- `python-packages.nix`: All Python package recipes and nixpkgs bug-fix overrides. Recipes take `torch`, `jax`, etc. as parameters without specifying versions. Temporary patches go in `packages/lib/patches/` with a comment referencing the upstream PR.
- `regular-packages.nix`: Non-Python packages (C/C++, Go, binaries).
- `overlays/flake-module.nix`: Composes both registries into a single overlay.

## Recipe Rules

- `pyproject = true` when possible
- `build-system` must be explicit (do not rely on setuptools default)
- `pythonImportsCheck` is mandatory
- `meta.platforms` must be explicit
- `doCheck = false` must have a comment explaining why
- Do not use `rec` — use `stdenv.mkDerivation (finalAttrs: { ... })` pattern
- Do not redefine dependencies already available in nixpkgs

## Build & Verify

```bash
nix build .#<name>
nix fmt -- --check .
```

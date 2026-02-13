# Contributing to stacks.nix

Nix package registry for ML, bioinformatics, and scientific computing.

## Repository Structure

```
packages/by-name/xx/<name>/package.nix   # Package recipe (2-letter prefix)
packages/lib/python-packages.nix         # Layer 1: Python package overlay registry
packages/lib/regular-packages.nix        # Layer 1: non-Python package registry
packages/lib/mk-nvidia-wheel.nix         # NVIDIA wheel builder
packages/lib/mk-wheel-package.nix        # Generic wheel builder
packages/lib/mk-cuda-env.nix             # CUDA runtime path helper
frameworks/                              # Layer 2: framework version overrides only
overlays/flake-module.nix                # Set composition (Layer 1 + Layer 2)
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
| 3 | Different version, expensive native build | Pre-built wheel | jaxlib, nvidia-\* |

## Builders in `packages/lib/`

| Builder | Purpose | When to use |
|---------|---------|-------------|
| `mkNvidiaWheel` | NVIDIA wheel packages (eliminates boilerplate) | Adding `nvidia-*-cu12` packages |
| `mkWheelPackage` | Generic Tier 3 wheel (multi-platform) | Adding Tier 3 packages like jaxlib, docling-parse |
| `mkCudaEnv` | CUDA runtime paths (LD\_LIBRARY\_PATH, etc.) | GPU wrapper apps or devShells needing CUDA paths |

Tier 3 packages separate platform hashes into `hashes.json`:

```
packages/by-name/ja/jaxlib/
├── package.nix      # calls mkWheelPackage
└── hashes.json      # { "version": "...", "platforms": { "3.12-x86_64-linux": "sha256-..." } }
```

## 2-Layer Overlay Model

- **Layer 1** (`python-packages.nix`): All package recipes. Framework-agnostic — recipes take `torch`, `jax`, etc. as parameters without specifying versions.
- **Layer 2** (`frameworks/`): Framework version overrides only. No package recipes.

A "set" is the composition of Layer 1 + a specific Layer 2 overlay:

```
packages overlay ─── all package recipes (defined once)
     │
     ├── + torch-latest overlay   = torch-latest set
     ├── + jax-034-cuda overlay   = jax-034-cuda set
     └── + (nothing)              = base set (nixpkgs defaults)
```

Every package exists in every set. The framework overlay determines which
torch/jax version it receives. Do not modify `frameworks/` when adding
regular packages.

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

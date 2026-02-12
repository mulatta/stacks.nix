# Overlay composition: combines Layer 1 (packages) with Layer 2 (frameworks)
# to produce package sets.
{ lib, ... }:
let
  byNamePackage = import ../packages/lib/by-name.nix;
  helpers = [
    "mkNvidiaWheel"
    "mkWheelPackage"
  ];
in
{
  flake.overlays.default =
    final: prev:
    let
      mkNvidiaWheel = final.python3Packages.callPackage ../packages/lib/mk-nvidia-wheel.nix { };
      mkWheelPackage = final.python3Packages.callPackage ../packages/lib/mk-wheel-package.nix { };

      # Layer 1: all package recipes
      packagesOverlay = import ../packages/lib/python-packages.nix {
        inherit byNamePackage mkNvidiaWheel mkWheelPackage;
      };

      # Auto-derive Python package names from overlay (lazy: values not evaluated)
      pythonPackageNames = builtins.filter (n: !builtins.elem n helpers) (
        builtins.attrNames (packagesOverlay (throw "unused") { })
      );

      # Layer 2: framework overlays
      torchLatestOverlay = import ../frameworks/torch-latest.nix { inherit byNamePackage; };
      jax034CudaOverlay = import ../frameworks/jax-034-cuda.nix { inherit byNamePackage; };

      # Set constructor
      mkSet =
        name: overlays:
        prev.python3.override {
          self = mkSet name overlays;
          packageOverrides = lib.composeManyExtensions overlays;
        };

      # Non-Python packages
      regularPackages = import ../packages/lib/regular-packages.nix {
        inherit byNamePackage;
        pkgs = final;
      };

      pythonSets = {
        base = mkSet "base" [ packagesOverlay ];
        torch-latest = mkSet "torch-latest" [
          packagesOverlay
          torchLatestOverlay
        ];
        jax-034-cuda = mkSet "jax-034-cuda" [
          packagesOverlay
          jax034CudaOverlay
        ];
      };
    in
    regularPackages
    // {
      inherit pythonSets;

      # Flat package collection for flake packages/checks output
      _stacksPackages = regularPackages // lib.getAttrs pythonPackageNames pythonSets.base.pkgs;

      # CUDA environment helper
      mkCudaEnv = final.callPackage ../packages/lib/mk-cuda-env.nix { };
    };
}

# Overlay: Python package recipes + non-Python packages
{ lib, ... }:
let
  byNamePackage = import ../packages/lib/by-name.nix;
in
{
  flake.overlays.default =
    final: prev:
    let
      packagesOverlay = import ../packages/lib/python-packages.nix {
        inherit byNamePackage;
      };

      # Auto-derive Python package names from overlay (lazy: values not evaluated)
      pythonPackageNames = builtins.attrNames (packagesOverlay (throw "unused") { });

      regularPackages = import ../packages/lib/regular-packages.nix {
        inherit byNamePackage;
        pkgs = final;
      };

      pythonSet = prev.python3.override {
        self = pythonSet;
        packageOverrides = packagesOverlay;
      };
    in
    regularPackages
    // {
      inherit pythonSet;

      # Flat package collection for flake packages/checks output
      _stacksPackages = regularPackages // lib.getAttrs pythonPackageNames pythonSet.pkgs;
    };
}

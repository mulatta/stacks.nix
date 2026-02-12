# Package exposition: surfaces packages and checks for CI.
# Package list is auto-derived from the overlay (_stacksPackages).
_: {
  perSystem =
    {
      pkgs,
      self',
      lib,
      ...
    }:
    {
      packages = pkgs._stacksPackages;

      checks =
        let
          packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") self'.packages;
          devShells = lib.mapAttrs' (n: lib.nameValuePair "devShell-${n}") self'.devShells;
        in
        packages // devShells;
    };
}

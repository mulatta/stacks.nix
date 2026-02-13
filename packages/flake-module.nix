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
      packages =
        let
          # Filter out packages unavailable on the current system (wrong platform,
          # broken, or throwing during evaluation).
          available = lib.filterAttrs (
            _: pkg:
            let
              r = builtins.tryEval (
                lib.meta.availableOn pkgs.stdenv.hostPlatform pkg && !(pkg.meta.broken or false)
              );
            in
            r.success && r.value
          ) pkgs._stacksPackages;
        in
        available;

      checks =
        let
          packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") self'.packages;
          devShells = lib.mapAttrs' (n: lib.nameValuePair "devShell-${n}") self'.devShells;
        in
        packages // devShells;
    };
}

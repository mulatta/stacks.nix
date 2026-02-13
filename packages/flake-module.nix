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
          # Filter out packages unavailable on the current system (wrong platform,
          # broken, or throwing during evaluation) so CI only builds what can succeed.
          buildable = lib.filterAttrs (
            _: pkg:
            let
              r = builtins.tryEval (
                lib.meta.availableOn pkgs.stdenv.hostPlatform pkg && !(pkg.meta.broken or false)
              );
            in
            r.success && r.value
          ) self'.packages;
          packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") buildable;
          devShells = lib.mapAttrs' (n: lib.nameValuePair "devShell-${n}") self'.devShells;
        in
        packages // devShells;
    };
}

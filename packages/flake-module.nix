# Package exposition: surfaces individual packages for CI (`nix build .#<name>`).
# pythonSets and mkCudaEnv are exposed via the overlay, not here.
_: {
  # Packages will be added here as they are migrated.
  # For now the overlay handles all exposition via pkgs.pythonSets.
}

# Layer 1: packages overlay
# All Python package recipes. Framework-agnostic.
# Packages receive torch/jax/etc as parameters without knowing which version.
{
  mkNvidiaWheel,
  mkWheelPackage,
}:
_py-self: _py-super: {
  # -- Helper builders available via callPackage --
  inherit mkNvidiaWheel mkWheelPackage;

  # -- Packages --
  # Add packages here as they are migrated.
  # Example:
  # paper-qa = py-self.callPackage (byNamePackage "paper-qa") { };
  # alphafold3 = py-self.callPackage (byNamePackage "alphafold3") { };
}

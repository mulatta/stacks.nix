# Layer 1: packages overlay
# All Python package recipes. Framework-agnostic.
# Packages receive torch/jax/etc as parameters without knowing which version.
{
  byNamePackage,
  mkNvidiaWheel,
  mkWheelPackage,
}:
py-self: _py-super: {
  # -- Helper builders available via callPackage --
  inherit mkNvidiaWheel mkWheelPackage;

  # -- Packages --
  biotite = py-self.callPackage (byNamePackage "biotite") { };
}

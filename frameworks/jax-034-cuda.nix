# Framework overlay: JAX 0.4.34 + CUDA
# Pins JAX ecosystem to 0.4.34 for packages that require it (e.g. alphafold3).
# nixpkgs JAX (0.6.x) is replaced within this set only.
{ byNamePackage }:
py-self: _py-super: {
  jax = py-self.callPackage (byNamePackage "jax") { };
  jaxlib = py-self.callPackage (byNamePackage "jaxlib") { };
  jaxtyping = py-self.callPackage (byNamePackage "jaxtyping") { };
  typeguard = py-self.callPackage (byNamePackage "typeguard") { };
}

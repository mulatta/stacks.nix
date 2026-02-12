# Framework overlay: torch (latest from nixpkgs, with patches)
# Applies UB fix patch to nixpkgs torch.
{ byNamePackage }:
_py-self: py-super: {
  torch = py-super.torch.overridePythonAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      # Fix UB: vector::reserve() followed by operator[]
      # Triggers SIGTRAP with nixpkgs libc++ _LIBCPP_HARDENING_MODE_EXTENSIVE
      (byNamePackage "torch-reserve-ub.patch")
    ];
  });
}

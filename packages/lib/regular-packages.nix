# Non-Python packages (C/C++, Go, Rust, binaries, etc.)
# These are independent of Python package sets.
{
  byNamePackage,
  pkgs,
}:
{
  foldseek = pkgs.callPackage (byNamePackage "foldseek") { };
}

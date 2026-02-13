# Non-Python packages (C/C++, Go, Rust, binaries, etc.)
# These are independent of Python package sets.
{
  byNamePackage,
  pkgs,
}:
{
  edirect = pkgs.callPackage (byNamePackage "edirect") { };
  foldseek = pkgs.callPackage (byNamePackage "foldseek") { };
  kalign2 = pkgs.callPackage (byNamePackage "kalign2") { };
  ncbi-dataformat = pkgs.callPackage (byNamePackage "ncbi-dataformat") { };
  ncbi-datasets = pkgs.callPackage (byNamePackage "ncbi-datasets") { };
}

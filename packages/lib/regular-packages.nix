# Non-Python packages (C/C++, Go, Rust, binaries, etc.)
# These are independent of Python package sets.
{
  byNamePackage,
  pkgs,
}:
{
  density-clustering-wasm = pkgs.callPackage (byNamePackage "density-clustering-wasm") { };
  duckdb-wasm-extensions = pkgs.callPackage (byNamePackage "duckdb-wasm-extensions") { };
  embedding-atlas-frontend = pkgs.callPackage (byNamePackage "embedding-atlas-frontend") { };
  edirect = pkgs.callPackage (byNamePackage "edirect") { };
  foldseek = pkgs.callPackage (byNamePackage "foldseek") { };
  kalign2 = pkgs.callPackage (byNamePackage "kalign2") { };
  umap-wasm = pkgs.callPackage (byNamePackage "umap-wasm") { };
  ncbi-datasets = pkgs.callPackage (byNamePackage "ncbi-datasets") { };
}

# Layer 1: packages overlay
# All Python package recipes. Framework-agnostic.
# Packages receive torch/jax/etc as parameters without knowing which version.
{
  byNamePackage,
}:
py-self: _py-super: {
  # -- Nixpkgs overrides --
  # line-profiler: Cython test fixture fails in sandbox (pythonRemoveTestsDir
  # deletes .pyx files before pytestCheckPhase runs)
  line-profiler = _py-super.line-profiler.overridePythonAttrs { doCheck = false; };

  # -- Packages --
  alphashape = py-self.callPackage (byNamePackage "alphashape") { };
  ankh = py-self.callPackage (byNamePackage "ankh") { };
  bioservices = py-self.callPackage (byNamePackage "bioservices") { };
  biotite = py-self.callPackage (byNamePackage "biotite") { };
  cpdb-protein = py-self.callPackage (byNamePackage "cpdb-protein") { };
  crawl4ai = py-self.callPackage (byNamePackage "crawl4ai") { };
  deepspeed = py-self.callPackage (byNamePackage "deepspeed") { };
  easydev = py-self.callPackage (byNamePackage "easydev") { };
  fair-esm = py-self.callPackage (byNamePackage "fair-esm") { };
  graphein = py-self.callPackage (byNamePackage "graphein") { };
  fake-http-header = py-self.callPackage (byNamePackage "fake-http-header") { };
  openfold = py-self.callPackage (byNamePackage "openfold") { };
  patchright = py-self.callPackage (byNamePackage "patchright") { };
  tf-playwright-stealth = py-self.callPackage (byNamePackage "tf-playwright-stealth") { };
}

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

  # -- Nixpkgs overrides --
  # line-profiler: Cython test fixture fails in sandbox (pythonRemoveTestsDir
  # deletes .pyx files before pytestCheckPhase runs)
  line-profiler = _py-super.line-profiler.overridePythonAttrs { doCheck = false; };

  # -- Packages --
  alphashape = py-self.callPackage (byNamePackage "alphashape") { };
  ankh = py-self.callPackage (byNamePackage "ankh") { };
  biotite = py-self.callPackage (byNamePackage "biotite") { };
  crawl4ai = py-self.callPackage (byNamePackage "crawl4ai") { };
  easydev = py-self.callPackage (byNamePackage "easydev") { };
  fair-esm = py-self.callPackage (byNamePackage "fair-esm") { };
  fake-http-header = py-self.callPackage (byNamePackage "fake-http-header") { };
  patchright = py-self.callPackage (byNamePackage "patchright") { };
  tf-playwright-stealth = py-self.callPackage (byNamePackage "tf-playwright-stealth") { };
}

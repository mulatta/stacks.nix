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

  # docling-parse: nixpkgs source build broken, using wheel
  docling-parse-bin = py-self.callPackage (byNamePackage "docling-parse-bin") { };
  docling-parse = py-self.docling-parse-bin;

  docling = _py-super.docling.overridePythonAttrs (old: {
    pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [
      "docling-parse"
      "typer"
    ];
    meta = old.meta // {
      inherit (py-self.docling-parse-bin.meta) platforms;
    };
  });

  # -- Packages --
  alphashape = py-self.callPackage (byNamePackage "alphashape") { };
  ankh = py-self.callPackage (byNamePackage "ankh") { };
  bioservices = py-self.callPackage (byNamePackage "bioservices") { };
  biotite = py-self.callPackage (byNamePackage "biotite") { };
  boltz = py-self.callPackage (byNamePackage "boltz") { };
  chembl-structure-pipeline = py-self.callPackage (byNamePackage "chembl-structure-pipeline") { };
  cpdb-protein = py-self.callPackage (byNamePackage "cpdb-protein") { };
  cuequivariance = py-self.callPackage (byNamePackage "cuequivariance") { };
  cuequivariance-ops-cu12 = py-self.callPackage (byNamePackage "cuequivariance-ops-cu12") { };
  cuequivariance-ops-torch-cu12 =
    py-self.callPackage (byNamePackage "cuequivariance-ops-torch-cu12")
      { };
  cuequivariance-torch = py-self.callPackage (byNamePackage "cuequivariance-torch") { };
  crawl4ai = py-self.callPackage (byNamePackage "crawl4ai") { };
  deepspeed = py-self.callPackage (byNamePackage "deepspeed") { };
  easydev = py-self.callPackage (byNamePackage "easydev") { };
  fair-esm = py-self.callPackage (byNamePackage "fair-esm") { };
  fhaviary = py-self.callPackage (byNamePackage "fhaviary") { };
  fhlmi = py-self.callPackage (byNamePackage "fhlmi") { };
  graphein = py-self.callPackage (byNamePackage "graphein") { };
  fake-http-header = py-self.callPackage (byNamePackage "fake-http-header") { };
  openfold = py-self.callPackage (byNamePackage "openfold") { };
  patchright = py-self.callPackage (byNamePackage "patchright") { };
  tf-playwright-stealth = py-self.callPackage (byNamePackage "tf-playwright-stealth") { };
}

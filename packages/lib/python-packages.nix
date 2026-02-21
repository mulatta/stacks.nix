# Layer 1: packages overlay
# All Python package recipes. Framework-agnostic.
# Packages receive torch/jax/etc as parameters without knowing which version.
{ byNamePackage }:
py-self: py-super: {
  # -- Nixpkgs overrides --
  # line-profiler: Cython test fixture fails in sandbox (pythonRemoveTestsDir
  # deletes .pyx files before pytestCheckPhase runs)
  line-profiler = py-super.line-profiler.overridePythonAttrs { doCheck = false; };

  # docling-parse: nixpkgs source build broken, using wheel
  docling-parse-bin = py-self.callPackage (byNamePackage "docling-parse-bin") { };
  docling-parse = py-self.docling-parse-bin;

  docling = py-super.docling.overridePythonAttrs (old: {
    pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [
      "docling-parse"
      "typer"
    ];
    meta = old.meta // {
      inherit (py-self.docling-parse-bin.meta) platforms;
    };
  });

  # torch: fix UB (reserve→resize) causing SIGTRAP on aarch64-darwin MPS
  # Remove after nixpkgs PR #489817 is merged
  torch = py-super.torch.overridePythonAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patches/torch-reserve-ub.patch ];
  });

  # -- Packages --
  alphashape = py-self.callPackage (byNamePackage "alphashape") { };
  ankh = py-self.callPackage (byNamePackage "ankh") { };
  bertopic = py-self.callPackage (byNamePackage "bertopic") { };
  bioc = py-self.callPackage (byNamePackage "bioc") { };
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
  conllu = py-self.callPackage (byNamePackage "conllu") { };
  crawl4ai = py-self.callPackage (byNamePackage "crawl4ai") { };
  embedding-atlas = py-self.callPackage (byNamePackage "embedding-atlas") { };
  datamapplot = py-self.callPackage (byNamePackage "datamapplot") { };
  deepspeed = py-self.callPackage (byNamePackage "deepspeed") { };
  easydev = py-self.callPackage (byNamePackage "easydev") { };
  fair-esm = py-self.callPackage (byNamePackage "fair-esm") { };
  flair = py-self.callPackage (byNamePackage "flair") { };
  fhaviary = py-self.callPackage (byNamePackage "fhaviary") { };
  fhlmi = py-self.callPackage (byNamePackage "fhlmi") { };
  graphein = py-self.callPackage (byNamePackage "graphein") { };
  fake-http-header = py-self.callPackage (byNamePackage "fake-http-header") { };
  langextract = py-self.callPackage (byNamePackage "langextract") { };
  mpld3 = py-self.callPackage (byNamePackage "mpld3") { };
  ldp = py-self.callPackage (byNamePackage "ldp") { };
  openfold = py-self.callPackage (byNamePackage "openfold") { };
  openreview-py = py-self.callPackage (byNamePackage "openreview-py") { };
  paper-qa = py-self.callPackage (byNamePackage "paper-qa") { };
  paper-qa-docling = py-self.callPackage (byNamePackage "paper-qa-docling") { };
  paper-qa-nemotron = py-self.callPackage (byNamePackage "paper-qa-nemotron") { };
  paper-qa-pymupdf = py-self.callPackage (byNamePackage "paper-qa-pymupdf") { };
  paper-qa-pypdf = py-self.callPackage (byNamePackage "paper-qa-pypdf") { };
  patchright = py-self.callPackage (byNamePackage "patchright") { };
  pptree = py-self.callPackage (byNamePackage "pptree") { };
  pyqtree = py-self.callPackage (byNamePackage "pyqtree") { };
  pylabeladjust = py-self.callPackage (byNamePackage "pylabeladjust") { };
  pytorch-revgrad = py-self.callPackage (byNamePackage "pytorch-revgrad") { };
  pyzotero = py-self.callPackage (byNamePackage "pyzotero") { };
  segtok = py-self.callPackage (byNamePackage "segtok") { };
  semanticscholar = py-self.callPackage (byNamePackage "semanticscholar") { };
  tensorflow-hub = py-self.callPackage (byNamePackage "tensorflow-hub") { };
  tensorflow-text = py-self.callPackage (byNamePackage "tensorflow-text") { };
  tf-playwright-stealth = py-self.callPackage (byNamePackage "tf-playwright-stealth") { };
  transformer-smaller-training-vocab =
    py-self.callPackage (byNamePackage "transformer-smaller-training-vocab")
      { };
  usearch = py-self.callPackage (byNamePackage "usearch") { };
}

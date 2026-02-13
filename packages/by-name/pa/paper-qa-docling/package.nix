{
  lib,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  docling,
  docling-core,
  paper-qa,
}:

buildPythonPackage {
  pname = "paper-qa-docling";
  inherit (paper-qa) version src;
  pyproject = true;

  sourceRoot = "${paper-qa.src.name}/packages/paper-qa-docling";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    docling
    docling-core
  ];

  # Circular dependency with paper-qa
  dontCheckRuntimeDeps = true;
  doCheck = false;

  meta = {
    inherit (paper-qa.meta) homepage;
    description = "PaperQA readers implemented using Docling";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}

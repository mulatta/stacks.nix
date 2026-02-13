{
  lib,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  pypdf,
  pdfplumber,
  pillow,
  pypdfium2,
  paper-qa,
}:

buildPythonPackage {
  pname = "paper-qa-pypdf";
  inherit (paper-qa) version src;
  pyproject = true;

  sourceRoot = "${paper-qa.src.name}/packages/paper-qa-pypdf";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pypdf
  ];

  optional-dependencies = {
    enhanced = [
      pdfplumber
      pillow
      pypdfium2
    ];
    media = [
      pillow
      pypdfium2
    ];
  };

  # Circular dependency with paper-qa
  dontCheckRuntimeDeps = true;
  doCheck = false;

  meta = {
    inherit (paper-qa.meta) homepage;
    description = "PaperQA readers implemented using PyPDF";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}

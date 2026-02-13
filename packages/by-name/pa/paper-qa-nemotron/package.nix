{
  lib,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  pillow,
  fhaviary,
  fhlmi,
  litellm,
  numpy,
  pypdfium2,
  tenacity,
  paper-qa,
}:

buildPythonPackage {
  pname = "paper-qa-nemotron";
  inherit (paper-qa) version src;
  pyproject = true;

  sourceRoot = "${paper-qa.src.name}/packages/paper-qa-nemotron";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pillow
    fhaviary
    fhlmi
    litellm
    numpy
    pypdfium2
    tenacity
  ]
  ++ fhaviary.optional-dependencies.image;

  # Circular dependency with paper-qa
  dontCheckRuntimeDeps = true;
  doCheck = false;

  meta = {
    inherit (paper-qa.meta) homepage;
    description = "PaperQA reader using Nvidia nemotron-parse VLM API";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  anyio,
  fhaviary,
  fhlmi,
  html2text,
  httpx,
  httpx-aiohttp,
  numpy,
  paper-qa-pypdf,
  pybtex,
  pydantic,
  pydantic-settings,
  rich,
  tantivy,
  tenacity,
  tiktoken,
  ldp,
  openreview-py,
  paper-qa-docling,
  paper-qa-nemotron,
  paper-qa-pymupdf,
  pillow,
  pyzotero,
  qdrant-client,
  sentence-transformers,
  unstructured,
  usearch,
}:

buildPythonPackage (finalAttrs: {
  pname = "paper-qa";
  version = "2026.01.05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Future-House";
    repo = "paper-qa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cb/OPssQU2crONycYJnl2e56o6qwFXfrwpLZWpH88GY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    anyio
    fhaviary
    fhlmi
  ]
  ++ fhaviary.optional-dependencies.llm
  ++ [
    html2text
    httpx
    httpx-aiohttp
    numpy
    paper-qa-pypdf
    pybtex
    pydantic
    pydantic-settings
    rich
    tantivy
    tenacity
    tiktoken
  ];

  optional-dependencies = {
    docling = [ paper-qa-docling ];
    image = [ pillow ] ++ fhlmi.optional-dependencies.image;
    ldp = [ ldp ];
    local = [ sentence-transformers ];
    memory = [
      ldp
      usearch
    ];
    nemotron = [ paper-qa-nemotron ];
    office = [
      unstructured
    ]
    ++ unstructured.optional-dependencies.docx
    ++ unstructured.optional-dependencies.xlsx
    ++ unstructured.optional-dependencies.pptx;
    openreview = [ openreview-py ];
    pymupdf = [ paper-qa-pymupdf ];
    pypdf-enhanced = paper-qa-pypdf.optional-dependencies.enhanced;
    pypdf-media = paper-qa-pypdf.optional-dependencies.media;
    qdrant = [ qdrant-client ];
    zotero = [
      paper-qa-pymupdf
      pyzotero
    ];
  };

  pythonImportsCheck = [ "paperqa" ];

  # Tests require network access and API keys
  doCheck = false;

  meta = {
    description = "LLM Chain for answering questions from documents";
    homepage = "https://github.com/Future-House/paper-qa";
    license = lib.licenses.asl20;
    mainProgram = "pqa";
    platforms = lib.platforms.unix;
  };
})

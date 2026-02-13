# TODO: Switch to native build (nixpkgs python3Packages.docling-parse) when
# nlohmann_json compatibility issue is resolved upstream.
# See: https://github.com/docling-project/docling-parse/issues/172
# Currently using pre-built wheel to avoid C++ compilation errors.
{
  lib,
  buildPythonPackage,
  fetchPypi,
  autoPatchelfHook,
  stdenv,
  python,
  zlib,
  libjpeg,
  qpdf,
  tabulate,
  pillow,
  pydantic,
  docling-core,
}:
buildPythonPackage (
  finalAttrs:
  let
    pyTag = "cp${lib.replaceStrings [ "." ] [ "" ] python.pythonVersion}";

    wheels = {
      "cp312-x86_64-linux" = {
        platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
        hash = "sha256-3DK28lpnPkG5qBEraBQohPYNusmDH3hIoDQ0Rg9XTq4=";
      };
      "cp312-aarch64-linux" = {
        platform = "manylinux_2_26_aarch64.manylinux_2_28_aarch64";
        hash = "sha256-3/0Z7Tc7DaXOoSRgBrGDSJqGhsPRhkPpSEW+HbXXE+o=";
      };
      "cp312-aarch64-darwin" = {
        platform = "macosx_14_0_arm64";
        hash = "sha256-2JIxqk+6PjjguAxb6HvAdWnpNML5NbtRv1eQT+/plLU=";
      };
      "cp313-x86_64-linux" = {
        platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
        hash = "sha256-9Kk/kflwVeGcreM7uVfYP4YV8dKgEDuJgnrKFrMaPiI=";
      };
      "cp313-aarch64-linux" = {
        platform = "manylinux_2_26_aarch64.manylinux_2_28_aarch64";
        hash = "sha256-nRilsfeeyr7jMcSXoZ8Z0oGg2G8kvL5dOeP9ib3E3zI=";
      };
      "cp313-aarch64-darwin" = {
        platform = "macosx_14_0_arm64";
        hash = "sha256-bLT+jGLeBrcOazjEvWCPQeo+nXFUpOBfmjxNiUT+OiU=";
      };
    };

    wheelKey = "${pyTag}-${stdenv.hostPlatform.system}";
    wheel =
      wheels.${wheelKey} or (throw "docling-parse ${finalAttrs.version}: no wheel for ${wheelKey}");
  in
  {
    pname = "docling-parse";
    version = "4.7.3";
    format = "wheel";

    src = fetchPypi {
      pname = "docling_parse";
      inherit (finalAttrs) version;
      format = "wheel";
      python = pyTag;
      dist = pyTag;
      abi = pyTag;
      inherit (wheel) platform hash;
    };

    nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      stdenv.cc.cc.lib # libstdc++
      zlib
      libjpeg
      qpdf
    ];

    dependencies = [
      tabulate
      pillow
      pydantic
      docling-core
    ];

    pythonImportsCheck = [ "docling_parse" ];

    meta = {
      description = "Simple package to extract text with coordinates from programmatic PDFs";
      homepage = "https://github.com/docling-project/docling-parse";
      license = lib.licenses.mit;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    };
  }
)

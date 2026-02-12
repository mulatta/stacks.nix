{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
}:
let
  version = "18.10.2";
  srcs = {
    x86_64-linux = fetchzip {
      url = "https://github.com/ncbi/datasets/releases/download/v${version}/linux-amd64.cli.package.zip";
      hash = "sha256-0F/WyG76bc50MFC3wBXa+yxjsAkY2Sw0BLAM9lAl9n4=";
      stripRoot = false;
    };
    aarch64-linux = fetchzip {
      url = "https://github.com/ncbi/datasets/releases/download/v${version}/linux-arm64.cli.package.zip";
      hash = "sha256-xTarEH5O1Fv/eE4SWTj6Pg4/55IJDDMAaEenfeIWVAk=";
      stripRoot = false;
    };
    x86_64-darwin = fetchzip {
      url = "https://github.com/ncbi/datasets/releases/download/v${version}/darwin-amd64.cli.package.zip";
      hash = "sha256-F8qqci56CKik82uXTg3Nqzfy5VByoJICikb8R/K2Q7o=";
      stripRoot = false;
    };
    aarch64-darwin = fetchzip {
      url = "https://github.com/ncbi/datasets/releases/download/v${version}/darwin-arm64.cli.package.zip";
      hash = "sha256-rBrXK8GVMhtpHQ5o2T3tRKXvOcnzrraBb1gyxlYsQOA=";
      stripRoot = false;
    };
  };
in
stdenv.mkDerivation {
  pname = "ncbi-dataformat";
  inherit version;

  src =
    srcs.${stdenv.hostPlatform.system}
      or (throw "ncbi-dataformat: unsupported platform ${stdenv.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 $src/dataformat $out/bin/dataformat
    runHook postInstall
  '';

  meta = {
    description = "NCBI Datasets dataformat tool for converting metadata formats";
    homepage = "https://www.ncbi.nlm.nih.gov/datasets/docs/v2/";
    changelog = "https://github.com/ncbi/datasets/releases";
    license = lib.licenses.publicDomain;
    platforms = builtins.attrNames srcs;
    mainProgram = "dataformat";
  };
}

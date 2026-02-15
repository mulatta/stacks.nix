{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  lld,
  wasm-bindgen-cli_0_2_100,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "density-clustering-wasm";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "embedding-atlas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ue+aq9FFAFqetD7upLGFFlDsDSNLv7hY2LMbRXbpTtA=";
  };

  sourceRoot = "source/packages/density-clustering";

  nativeBuildInputs = [
    cargo
    rustc
    lld
    rustPlatform.cargoSetupHook
    wasm-bindgen-cli_0_2_100
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src sourceRoot;
    hash = "sha256-eJvAGdTwhPSO7USsJVrfPQfUzzdEJ/ALYtKwSbuwk1U=";
  };

  buildPhase = ''
    runHook preBuild

    cargo build \
      --target wasm32-unknown-unknown \
      --release \
      -p density_clustering_wasm

    wasm-bindgen \
      --target web \
      --out-dir pkg \
      target/wasm32-unknown-unknown/release/density_clustering_wasm.wasm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/pkg
    cp pkg/* $out/pkg/
    runHook postInstall
  '';

  meta = {
    description = "Density-based clustering compiled to WebAssembly";
    homepage = "https://github.com/apple/embedding-atlas";
    changelog = "https://github.com/apple/embedding-atlas/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mulatta ];
    platforms = lib.platforms.unix;
  };
})

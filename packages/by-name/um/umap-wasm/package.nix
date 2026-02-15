{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  emscripten,
}:

let
  # C++ header-only dependencies
  umappp = fetchFromGitHub {
    owner = "libscran";
    repo = "umappp";
    rev = "e6a0ad380594e8b67c3b5f1ba4b1e201c1cf33a7";
    hash = "sha256-2z4AOFwwYBP2ncOpOtwXnqUdvw8QRUqOpDJB2jkA0K4=";
  };

  knncolle = fetchFromGitHub {
    owner = "knncolle";
    repo = "knncolle";
    rev = "513dc09b8a681274da83df97c3d5b353a2b61c4b";
    hash = "sha256-uBqirf2Sev+wCl40bcJTAwS8U10OEY3qo9ESd+ZgMdY=";
  };

  cppKmeans = fetchFromGitHub {
    owner = "LTLA";
    repo = "CppKmeans";
    tag = "v3.1.2";
    hash = "sha256-JuraovE2dxNADL3qKpxtstzcucyfFGti6m0QsBKyfJM=";
  };

  subpar = fetchFromGitHub {
    owner = "LTLA";
    repo = "subpar";
    tag = "v0.3.2";
    hash = "sha256-F4pIzZWaDSBAuStpOIjBSIUon4FIi/Wq2NdlJcl+8Ps=";
  };

  aarand = fetchFromGitHub {
    owner = "LTLA";
    repo = "aarand";
    tag = "v1.0.2";
    hash = "sha256-gDuaBsu6Qja0kYQ32BX17EL3RPV1zVXRp+L7Pg8PMsk=";
  };

  cppIrlba = fetchFromGitHub {
    owner = "LTLA";
    repo = "CppIrlba";
    tag = "v2.0.2";
    hash = "sha256-7jUDtKY1IDFyGGb4rNt04GpU7ODKbCys6rzgn71TOyY=";
  };

  eigen = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    tag = "3.4.0";
    hash = "sha256-1/4xMetKMDOgZgzz3WMxfHUEpmdAm52RqZvz6i0mLEw=";
  };

  knncolle_hnsw = fetchFromGitHub {
    owner = "knncolle";
    repo = "knncolle_hnsw";
    rev = "024b9dda025079c8c988a79f8b69e1f54b94b507";
    hash = "sha256-Z0Y94gsMf4gIX6jgsQtQ/rHlaQaxX5McnE5aF5+8bnA=";
  };

  hnswlib = fetchFromGitHub {
    owner = "nmslib";
    repo = "hnswlib";
    tag = "v0.8.0";
    hash = "sha256-1KkAX42j/I06KO4wCnDsDifN1JiENqYKR5NNHBjyuVA=";
  };

  nndescent = fetchFromGitHub {
    owner = "brj0";
    repo = "nndescent";
    rev = "514275f263be010712530a95e56ffc9b81b9110b";
    hash = "sha256-9vEoVnnZYlJcZD5SeU5vWJqc+LixNwF+0Z/oYXUupPY=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "umap-wasm";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "embedding-atlas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ue+aq9FFAFqetD7upLGFFlDsDSNLv7hY2LMbRXbpTtA=";
  };

  sourceRoot = "source/packages/umap-wasm";

  nativeBuildInputs = [ emscripten ];

  postPatch = ''
    mkdir -p third_party

    # Header-only libraries: symlink (read-only OK)
    ln -s ${umappp} third_party/umappp
    ln -s ${knncolle} third_party/knncolle
    ln -s ${cppKmeans} third_party/CppKmeans
    ln -s ${subpar} third_party/subpar
    ln -s ${aarand} third_party/aarand
    ln -s ${cppIrlba} third_party/CppIrlba
    ln -s ${eigen} third_party/Eigen
    ln -s ${knncolle_hnsw} third_party/knncolle_hnsw
    ln -s ${hnswlib} third_party/hnswlib

    # nndescent needs patching -> copy writable
    cp -r ${nndescent} third_party/nndescent
    chmod -R u+w third_party/nndescent
    patch -d third_party/nndescent -p1 < third_party/nndescent.patch
  '';

  # Emscripten sandbox setup
  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR
    mkdir -p .emscriptencache
    export EM_CACHE=$(pwd)/.emscriptencache

    # Remove pre-built binary to force source build
    rm -f runtime.js
    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 runtime.js $out/runtime.js
    runHook postInstall
  '';

  meta = {
    description = "UMAP algorithm compiled to WebAssembly via Emscripten";
    homepage = "https://github.com/apple/embedding-atlas";
    changelog = "https://github.com/apple/embedding-atlas/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mulatta ];
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  umap-wasm,
  density-clustering-wasm,
  duckdb-wasm-extensions,
}:

buildNpmPackage (finalAttrs: {
  pname = "embedding-atlas-frontend";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "embedding-atlas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ue+aq9FFAFqetD7upLGFFlDsDSNLv7hY2LMbRXbpTtA=";
  };

  npmDepsHash = "sha256-zGx0WIbgDfHcMSN4nFGsruwdRZQhqRCnKgS2S+lgFzw=";

  postPatch = ''
    # Inject pre-built umap-wasm runtime.js
    cp ${umap-wasm}/runtime.js packages/umap-wasm/runtime.js

    # Inject pre-built density-clustering WASM
    rm -rf packages/density-clustering/density_clustering_wasm/pkg
    cp -r ${density-clustering-wasm}/pkg packages/density-clustering/density_clustering_wasm/pkg

    # Inject DuckDB WASM extensions into viewer public dir
    mkdir -p packages/viewer/public
    cp -r ${duckdb-wasm-extensions}/duckdb-wasm packages/viewer/public/duckdb-wasm

    # Replace WASM build scripts with noops (already pre-built)
    substituteInPlace packages/umap-wasm/package.json \
      --replace-fail '"build": "make"' '"build": "echo skip"'
    substituteInPlace packages/density-clustering/package.json \
      --replace-fail '"build": "npm run build:wasm && npm run build:binding"' '"build": "echo skip"'

    # Remove DuckDB download from viewer build script
    substituteInPlace packages/viewer/package.json \
      --replace-fail '"build": "uv run python scripts/download_duckdb_extensions.py && vite build && vite build --config vite.config.lib.js"' \
      '"build": "vite build && vite build --config vite.config.lib.js"'
  '';

  # Build workspace packages in dependency order
  buildPhase = ''
    runHook preBuild

    # 1. utils (TypeScript only)
    npm run --workspace=packages/utils build

    # 2. component (Vite/Svelte)
    npm run --workspace=packages/component build

    # 3. table (Vite/Svelte)
    npm run --workspace=packages/table build

    # 4. umap-wasm (noop, already built)
    npm run --workspace=packages/umap-wasm build

    # 5. density-clustering (noop, already built)
    npm run --workspace=packages/density-clustering build

    # 6. viewer (Vite — produces dist/ and distlib/)
    npm run --workspace=packages/viewer build

    # 7. embedding-atlas npm package
    npm run --workspace=packages/embedding-atlas build

    # 8. backend widget builds (anywidget + streamlit)
    npm run --workspace=packages/backend build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Viewer dist (static files for the Python web server)
    mkdir -p $out/viewer-dist
    cp -r packages/viewer/dist/* $out/viewer-dist/

    # Widget static (anywidget + streamlit)
    mkdir -p $out/widget_static
    cp -r packages/backend/embedding_atlas/widget_static/* $out/widget_static/

    runHook postInstall
  '';

  meta = {
    description = "Embedding Atlas frontend (viewer + widget static assets)";
    homepage = "https://github.com/apple/embedding-atlas";
    changelog = "https://github.com/apple/embedding-atlas/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mulatta ];
    platforms = lib.platforms.unix;
  };
})

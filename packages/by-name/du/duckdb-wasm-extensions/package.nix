{
  lib,
  fetchurl,
  linkFarm,
}:

let
  version = "1.3.2";

  extensions = [
    {
      name = "json";
      variant = "wasm_eh";
      hash = "sha256-9huc1XGD4ubmAeWEa9g2bb/oV4TV8G3883VtmgNYau0=";
    }
    {
      name = "json";
      variant = "wasm_mvp";
      hash = "sha256-t9w80VZQDAKUKE/lYhOth852bwNvh1jCqGN/bTI7KFc=";
    }
    {
      name = "fts";
      variant = "wasm_eh";
      hash = "sha256-gF50/rGI+0KJe9aqzH/BIoeWXrYUt6PIzSg6dFaxZeA=";
    }
    {
      name = "fts";
      variant = "wasm_mvp";
      hash = "sha256-GkC9UEfE3aM9HwPSvlJydoaHHnl3DM+7os/xQrhiPHE=";
    }
    {
      name = "parquet";
      variant = "wasm_eh";
      hash = "sha256-DNjbruuldz6CJUsqKuEV2LrDO2flWx1bVTCHlrX4bOA=";
    }
    {
      name = "parquet";
      variant = "wasm_mvp";
      hash = "sha256-3KgmK8adpCEO9gnWBrnogSIIizwx/NAZ5Ulxv9/AxVU=";
    }
  ];

  fetchExt =
    {
      name,
      variant,
      hash,
    }:
    {
      name = "duckdb-wasm/v${version}/${variant}/${name}.duckdb_extension.wasm";
      path = fetchurl {
        url = "https://extensions.duckdb.org/v${version}/${variant}/${name}.duckdb_extension.wasm";
        inherit hash;
      };
    };
in
linkFarm "duckdb-wasm-extensions-${version}" (map fetchExt extensions)
// {
  meta = {
    description = "DuckDB WASM extensions (json, fts, parquet)";
    homepage = "https://duckdb.org/";
    changelog = "https://github.com/duckdb/duckdb/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mulatta ];
    platforms = lib.platforms.all;
  };
}

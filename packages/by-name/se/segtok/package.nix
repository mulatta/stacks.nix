{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  regex,
}:
buildPythonPackage (finalAttrs: {
  pname = "segtok";
  version = "1.5.11";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-irLdRCRby/7CW1ddxGGEc7vfKvjCZJaYzVo3D0Lz2yM=";
  };

  build-system = [ setuptools ];

  dependencies = [ regex ];

  # tests require network access
  doCheck = false;

  pythonImportsCheck = [ "segtok" ];

  meta = {
    description = "Sentence segmentation and word tokenization tools";
    homepage = "https://github.com/fnl/segtok";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

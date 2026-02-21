{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  # dependencies
  colorcet,
  colorspacious,
  dask,
  datashader,
  importlib-resources,
  jinja2,
  matplotlib,
  numba,
  numpy,
  pandas,
  pyarrow,
  pylabeladjust,
  requests,
  rcssmin,
  rjsmin,
  scikit-image,
  scikit-learn,
  platformdirs,
  typing-extensions,
  pythonOlder,
}:
buildPythonPackage (finalAttrs: {
  pname = "datamapplot";
  version = "0.6.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-qiUwGrCgiuyhHAVADY6a2UzOsm+EpNlRgwJuN939qq8=";
  };

  build-system = [ setuptools ];

  # nixpkgs dask is newer than the pinned upper bound
  pythonRelaxDeps = [ "dask" ];

  dependencies = [
    colorcet
    colorspacious
    dask
    datashader
    importlib-resources
    jinja2
    matplotlib
    numba
    numpy
    pandas
    pyarrow
    pylabeladjust
    requests
    rcssmin
    rjsmin
    scikit-image
    scikit-learn
    platformdirs
    typing-extensions
  ];

  # tests require GPU and large datasets
  doCheck = false;

  # numba @jit(cache=True) in datashader tries to cache in read-only nix store
  postFixup = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)
  '';

  pythonImportsCheck = [ "datamapplot" ];

  meta = {
    description = "Creating beautiful plots of data maps";
    homepage = "https://github.com/TutteInstitute/datamapplot";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

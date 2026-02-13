{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  pycryptodome,
  requests,
  tqdm,
  deprecated,
  pylatexenc,
  tld,
  pyjwt,
  numpy,
  litellm,
}:

buildPythonPackage (finalAttrs: {
  pname = "openreview-py";
  version = "1.56.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openreview";
    repo = "openreview-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4zvegudOfS6dfjAUr6xziVat3BsBICSTU90iy5H5pTc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'litellm==1.76.1' 'litellm' \
      --replace-fail '"future",' ""
  '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    pycryptodome
    requests
    tqdm
    deprecated
    pylatexenc
    tld
    pyjwt
    numpy
    litellm
  ];

  pythonImportsCheck = [ "openreview" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "OpenReview API Python client library";
    homepage = "https://github.com/openreview/openreview-py";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

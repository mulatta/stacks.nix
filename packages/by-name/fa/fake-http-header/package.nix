{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
buildPythonPackage (_finalAttrs: {
  pname = "fake-http-header";
  version = "0.3.5-unstable-2024-01-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MichaelTatarski";
    repo = "fake-http-header";
    rev = "0f110477d3ecae916e88608a123360227bfb6109";
    hash = "sha256-CznvDjzUeA0THsiIhuzvEDb4gXsP8IujpSCjt857qSo=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "fake_http_header" ];

  # No test suite included in source distribution
  doCheck = false;

  meta = {
    description = "Generate fake HTTP headers for web crawlers";
    homepage = "https://github.com/MichaelTatarski/fake-http-header";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  # dependencies
  playwright,
  fake-http-header,
  urllib3,
}:
buildPythonPackage (_finalAttrs: {
  pname = "tf-playwright-stealth";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinyfish-io";
    repo = "tf-playwright-stealth";
    rev = "e8aa6d09c17577deee9be59b4b71d95b0d746e9b";
    hash = "sha256-UP/cNvsQe1HpfqA75t4cVsiKqysq746S7hrzz9O/If0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    playwright
    fake-http-header
    urllib3
  ];

  pythonImportsCheck = [ "playwright_stealth" ];

  # Tests require browser runtime
  doCheck = false;

  meta = {
    description = "Makes Playwright stealthy like a ninja";
    homepage = "https://github.com/tinyfish-io/tf-playwright-stealth";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})

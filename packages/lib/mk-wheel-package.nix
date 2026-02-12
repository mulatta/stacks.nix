# Builder for generic Tier 3 multi-platform wheel packages.
# Used for packages like jaxlib, docling-parse that provide
# platform-specific pre-built wheels.
#
# Usage:
#   mkWheelPackage {
#     pname = "jaxlib";
#     version = "0.4.34";
#     platforms = {
#       "3.11-x86_64-linux" = fetchPypi { ... };
#       "3.12-x86_64-linux" = fetchPypi { ... };
#     };
#     dependencies = [ absl-py scipy ];
#   }
{
  lib,
  buildPythonPackage,
  autoPatchelfHook,
  stdenv,
  python,
}:

{
  pname,
  version,
  platforms,
  dependencies ? [ ],
  ...
}@args:

let
  platformKey = "${python.pythonVersion}-${stdenv.hostPlatform.system}";
  src =
    platforms.${platformKey} or (throw "${pname} ${version}: unsupported platform ${platformKey}");
in
buildPythonPackage (
  {
    inherit
      pname
      version
      src
      dependencies
      ;
    format = "wheel";
    nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  }
  // removeAttrs args [
    "pname"
    "version"
    "platforms"
    "dependencies"
  ]
)

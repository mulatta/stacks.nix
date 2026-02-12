# Builder for NVIDIA Python wheel packages.
# Eliminates boilerplate across nvidia-cublas-cu12, nvidia-cudnn-cu12, etc.
#
# Usage:
#   mkNvidiaWheel {
#     pname = "nvidia-cublas-cu12";
#     version = "12.6.3.3";
#     hash = "sha256-...";
#   }
{
  buildPythonPackage,
  fetchPypi,
  lib,
  autoPatchelfHook,
  stdenv,
}:

{
  pname,
  version,
  hash,
  platform ? "manylinux2014_x86_64",
  buildInputs ? [ (lib.getLib stdenv.cc.cc) ],
  dependencies ? [ ],
  ...
}@args:

buildPythonPackage (
  {
    inherit pname version;
    format = "wheel";

    src = fetchPypi {
      pname = builtins.replaceStrings [ "-" ] [ "_" ] pname;
      inherit version;
      format = "wheel";
      dist = "py3";
      python = "py3";
      abi = "none";
      inherit platform hash;
    };

    nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
    inherit buildInputs dependencies;

    # PEP 420 implicit namespace: remove __init__.py to prevent collisions
    # when multiple nvidia-* packages are installed together
    postInstall = ''
      rm -f $out/lib/python*/site-packages/nvidia/__init__.py
      rm -rf $out/lib/python*/site-packages/nvidia/__pycache__
    '';

    meta = {
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  }
  // removeAttrs args [
    "pname"
    "version"
    "hash"
    "platform"
    "buildInputs"
    "dependencies"
  ]
)

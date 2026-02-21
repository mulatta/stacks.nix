{
  lib,
  buildPythonPackage,
  fetchurl,
  autoPatchelfHook,
  stdenv,
  python,
  tensorflow,
}:
buildPythonPackage (
  finalAttrs:
  let
    pyTag = "cp${lib.replaceStrings [ "." ] [ "" ] python.pythonVersion}";

    wheels = {
      "cp311-x86_64-linux" = {
        url = "https://files.pythonhosted.org/packages/7d/15/61c813ca3a6de9369e97f496a81b879da1e2aa3710732662a1a2d4a2d69f/tensorflow_text-2.20.0-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
        hash = "sha256-ic6eaCFBHka69zI7FyFrXAiOZ/3xIjYSjMJxByQa3P0=";
      };
      "cp311-aarch64-linux" = {
        url = "https://files.pythonhosted.org/packages/5f/4b/51922b2d272fc4623c7fcf4f3dac3a191e799eaa581fee1b8fc09ab586da/tensorflow_text-2.20.0-cp311-cp311-manylinux2014_aarch64.manylinux_2_17_aarch64.whl";
        hash = "sha256-Qa9d90PAfKGO5dZuhuro3ZKc0Bqak6zQ60LQCNUkEB4=";
      };
      "cp311-aarch64-darwin" = {
        url = "https://files.pythonhosted.org/packages/20/3b/d9ed34802d4a5911023bb3e784abb828e974c736887a500de71e7fe09f11/tensorflow_text-2.20.0-cp311-cp311-macosx_11_0_arm64.whl";
        hash = "sha256-FkddlCiLYiHLFhNtKj8QEEqnfGM0YJjy5jKG86Gc4gg=";
      };
      "cp312-x86_64-linux" = {
        url = "https://files.pythonhosted.org/packages/c3/e6/cfd784298ffb759a4235721cac2ac20f7ff758bf687069cfbaebb06c5804/tensorflow_text-2.20.0-cp312-cp312-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
        hash = "sha256-u25PNBAcje2WRdukxKaTp5Hf+fe8ZK4+nwQLezr+fBo=";
      };
      "cp312-aarch64-linux" = {
        url = "https://files.pythonhosted.org/packages/f5/ca/796cfd97ae6693d3c84c37575a6d481be5f1ef36c920d1a73c884f31797b/tensorflow_text-2.20.0-cp312-cp312-manylinux2014_aarch64.manylinux_2_17_aarch64.whl";
        hash = "sha256-HWFZ/WG6GMP+1FgRWVpKNJqPIMhXoBqVh5mA/brhz4o=";
      };
      "cp312-aarch64-darwin" = {
        url = "https://files.pythonhosted.org/packages/98/e4/e3c72d0a73caeba90cf5b31e69d44e9a08d614e0e829484d813f3b63e037/tensorflow_text-2.20.0-cp312-cp312-macosx_11_0_arm64.whl";
        hash = "sha256-gR9xNUl6cXPaN1eXdJrx58APexukIeXbOD4Fp7/HRos=";
      };
    };

    wheelKey = "${pyTag}-${stdenv.hostPlatform.system}";
    wheelAvailable = builtins.hasAttr wheelKey wheels;
    wheel =
      wheels.${wheelKey} or (throw "tensorflow-text ${finalAttrs.version}: no wheel for ${wheelKey}");
  in
  {
    pname = "tensorflow-text";
    version = "2.20.0";
    format = "wheel";

    # only cp311/cp312 wheels available on PyPI
    disabled = !wheelAvailable;

    src = fetchurl wheel;

    nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

    # tensorflow version in nixpkgs may differ from pinned range
    pythonRelaxDeps = [ "tensorflow" ];

    dependencies = [ tensorflow ];

    # requires tensorflow runtime with matching version
    doCheck = false;

    pythonImportsCheck = [ "tensorflow_text" ];

    meta = {
      description = "TF.Text is a TensorFlow library of text related ops and modules";
      homepage = "https://github.com/tensorflow/text";
      license = lib.licenses.asl20;
      # no x86_64-darwin wheel available
      platforms = lib.platforms.linux ++ [ "aarch64-darwin" ];
    };
  }
)

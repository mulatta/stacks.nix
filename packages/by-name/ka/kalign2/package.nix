{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "kalign2";
  version = "2.04";

  src = fetchurl {
    url = "https://msa.sbc.su.se/downloads/kalign/current.tar.gz";
    hash = "sha256-jPIKxOGAfcZC5/+6j0KhFzE77MruT4fFVV1Tou6sTLs=";
  };

  # The tarball extracts without a top-level directory
  sourceRoot = ".";

  postPatch = ''
    # Makefile.in hardcodes gcc and -O9; let configure set them
    substituteInPlace Makefile.in \
      --replace-fail '= gcc' '= @CC@' \
      --replace-fail '-O9  -Wall' '@CFLAGS@'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 kalign -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "A fast and accurate multiple sequence alignment algorithm";
    homepage = "http://msa.sbc.su.se/cgi-bin/msa.cgi";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kalign";
  };
}

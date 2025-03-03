{
  lib,
  stdenv,
  fetchFromGitLab,
}:
stdenv.mkDerivation {
  pname = "refind-theme-hai";
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.blahai.gay";
    owner = "elissa";
    repo = "refind-theme-hai";
    tag = "0.1.0";
    hash = "sha256-/5DTLBT/4RfxmyxtpVL0bVbdteL8GMOdFMUbgf8C09A=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r {icons,theme.conf,*.png} $out/
  '';

  meta = {
    description = "rEFInd theme based on the nord theme";
    homepage = "https://gitlab.blahai.gay/elissa/refind-theme-hai";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}

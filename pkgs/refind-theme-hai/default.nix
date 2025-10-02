{
  lib,
  stdenv,
  fetchFromGitLab,
}:
stdenv.mkDerivation {
  pname = "refind-theme-hai";
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "git.elissa.moe";
    owner = "elissa";
    repo = "refind-theme-hai";
    tag = "0.1.0";
    hash = "sha256-zqMaqYwdaidn8FfH9TouY3XfcyzX5RDxTDdJES7HtQA=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r {icons,theme.conf,*.png} $out/
  '';

  meta = {
    description = "rEFInd theme based on the nord theme";
    homepage = "https://git.elissa.moe/elissa/refind-theme-hai";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}

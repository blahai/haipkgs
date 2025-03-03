{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "rEFInd-minimal";
  version = "2023-09-21";

  src = fetchFromGitHub {
    owner = "evanpurkhiser";
    repo = "rEFInd-minimal";
    rev = "cbebdb063072d4b1abfc0eef6bac26e9273abdf1";
    sha256 = "sha256-YGyd5WEBm36dFtcOgVqPzQhXExHAPL9b038LoVa/Mp4=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';

  meta = with lib; {
    description = "A minimal theme for rEFInd";
    homepage = "https://github.com/evanpurkhiser/rEFInd-minimal";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}

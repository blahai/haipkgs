{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "oneui4-icons";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "mjkim0727";
    repo = "OneUI4-Icons";
    rev = "4ed5ceb912e758a8f7095f2008c84ffd7155bc14";
    sha256 = "sha256-f5t7VGPmD+CjZyWmhTtuhQjV87hCkKSCBksJzFa1x1Y=";
  };

  patchPhase = ''
    # Remove broken symlinks
    find . -xtype l -delete
  '';

  installPhase = ''
    install -d $out/share/icons
    cp -dr --no-preserve=mode OneUI{,-dark,-light} $out/share/icons/
  '';

  meta = {
    description = "One UI Icons for Linux ";
    homepage = "https://github.com/mjkim0727/OneUI4-Icons";
    license = lib.licenses.gpl3;
  };
}

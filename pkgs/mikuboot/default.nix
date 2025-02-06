{
  stdenvNoCC,
  lib,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "plymouth-mikuboot-theme";
  version = "1.0";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/plymouth/themes
    mv mikuboot $out/share/plymouth/themes/mikuboot
    sed -i "s@\/usr\/@$out\/@" $out/share/plymouth/themes/mikuboot/mikuboot.plymouth
  '';

  meta = {
    description = "A miku boot animation because she's living in my computer.";
    longDescription = ''
      Hatsune Miku plymouth theme made by
      inspired by the miku song "oo ee oo"
      yoinked from https://gitlab.com/EvysGarden/mikuboot
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}

{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  rename,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2025-08-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "b2c0f61d8a99224bd99924f3d0471d9f146c9a54";
    hash = "sha256-5bcEh7Oetd2JmFEPCcoweDrLGQTpcuaCU8hCjz8ls3M=";
    sparseCheckout = ["variablefont"];
  };

  nativeBuildInputs = [rename];

  installPhase = ''
    runHook preInstall

    rename 's/\[FILL,GRAD,opsz,wght\]//g' variablefont/*
    install -Dm755 variablefont/*.ttf -t $out/share/fonts/TTF
    install -Dm755 variablefont/*.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };
  };

  meta = {
    description = "Material Symbols icons by Google";
    homepage = "https://fonts.google.com/icons";
    downloadPage = "https://github.com/google/material-design-icons";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fufexan
      luftmensch-luftmensch
    ];
    platforms = lib.platforms.all;
  };
}

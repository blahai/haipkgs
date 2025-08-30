{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  rename,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2025-08-29";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "d7730556b31d3493ccc0450f66bf49544b6f8a79";
    hash = "sha256-B0tJrkaVL/pYPTKSYo6klqTRxXc8h8djFxG2s4nYIjQ=";
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

{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  rename,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2025-09-12";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "72a762ec68a3bc581eb1703cb9c7773f6ff60640";
    hash = "sha256-uisCkvndO56HqpL+hO1ihJK8QVLL6eOhRIGRqHFzkMM=";
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

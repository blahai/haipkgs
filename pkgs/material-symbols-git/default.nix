{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  rename,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2025-09-05";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "75796481058b032be5bfe743eda35d2464be282c";
    hash = "sha256-rCWRsFVjC17RdZyN+j5wLaeuhZIW5RujrFWV4dv7lHo=";
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

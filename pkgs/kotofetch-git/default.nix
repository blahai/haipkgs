{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.17-unstable-2025-10-05";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "099964cbec40085b07d486683f68d45cc96554a8";
    hash = "sha256-MfBDXKBzEU1+BkkBeFtpZjgpKn6iares/fACea2/BVM=";
  };

  cargoHash = "sha256-0es6IUH4hHue7uzfZbTlfqUPBYi7U7txy0t8xcxA5V8=";

  strictDeps = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "small, configurable CLI that displays Japanese quotes in the terminal.";
    homepage = "https://github.com/hxpe-dev/kotofetch";
    license = lib.licenses.mit;
    mainProgram = "kotofetch";
    maintainers = [];
  };
})

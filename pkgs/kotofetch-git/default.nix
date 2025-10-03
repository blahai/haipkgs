{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.16-unstable-2025-10-02";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "9b5aeee90e10e24028b06d27cf47f736e8b107d9";
    hash = "sha256-bxIgIab2yBIZBafpndgn7sILUM9qQWPWxJKAg4RMKug=";
  };

  cargoHash = "sha256-GntAf9CeLBGfEzLi2H+1Wz8vGlbsWl0CJXmp7EmD9/s=";

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

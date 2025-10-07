{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.17-unstable-2025-10-06";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "336ba307ff8bc15b02bdeb4300a43802d9c649ba";
    hash = "sha256-JOBIEOKGM4U+plv5Sn6oadPm/g6VO0P9n4cotmDwodc=";
  };

  cargoHash = "sha256-APBAxVhbjSpySoPcHlhQcQPE4ysG/fyYPC6RTlJHUG8=";

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

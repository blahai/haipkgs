{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.15-unstable-2025-10-01";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "ebe55e69bcabe851a1b64d9068a975a995cc5c81";
    hash = "sha256-rihmGTdHzgr8cRvi+f4cVHyhTH0BWYlGTSDmmn2/4Xs=";
  };

  cargoHash = "sha256-mlS1MS4t8RE8/9za+4wVTbnfKlf1z0m1qLDn7yQXChY=";

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

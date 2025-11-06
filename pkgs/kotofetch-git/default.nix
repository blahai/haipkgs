{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.18-unstable-2025-11-05";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "33bed96ffd4a91ea860396a9d225caa1ca9630ff";
    hash = "sha256-8njFXrqqoJHWUc3Q2pQ60umqz9DS7+Sn/C6DFXsUpY8=";
  };

  cargoHash = "sha256-DTZXHdvuTF2mXHrQQJvsnDopjF1lK0p0nck+dwskIGw=";

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

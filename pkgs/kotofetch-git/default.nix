{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.18-unstable-2025-11-02";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "8e9a9001fff26b075d98d0e5559d812e867bca59";
    hash = "sha256-GYMNMZ5wXZEeTuZe2ZV/SKtrOZq0lZAWPyn7cARiXLg=";
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

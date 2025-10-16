{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.18-unstable-2025-10-15";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "fc5491290dc7b76d53298601855f1264fd7ca458";
    hash = "sha256-Pf/XtjpGzXuAryT0OpZZQvanD6J0nVmRj/9RAJytgls=";
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

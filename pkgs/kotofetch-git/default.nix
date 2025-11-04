{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.18-unstable-2025-11-03";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "9b3a4e85adb94d2ab9a6e170e789417582f3c28c";
    hash = "sha256-0fbDq1WlPmpEyTIWObu+mJttVz7FpvpP0qukKrHzLtk=";
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

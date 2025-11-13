{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.18-unstable-2025-11-12";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "710517cfd9f783d0d6c0ea996d6adbd7c07f32ae";
    hash = "sha256-cJaGPwMMtAwYV6h7Ore4QxdzTbvykc8VU8BhMQOMesw=";
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

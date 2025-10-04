{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.17-unstable-2025-10-03";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "b79eb83035451fe4a995e0c2acada91d54c6a8f4";
    hash = "sha256-/qJ92Hi3uVUzKwAzCTekEZlTf4Gb5AgYvWkRKof01JI=";
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

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kotofetch-git";
  version = "0.2.17-unstable-2025-10-04";

  src = fetchFromGitHub {
    owner = "hxpe-dev";
    repo = "kotofetch";
    rev = "ab242531931641f835de9f50f733a52acf12c751";
    hash = "sha256-M6OEtwyGWAxexVac00lIxNfXJJKU0xPpafNoZQnq7n8=";
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

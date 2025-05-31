{
  fetchFromGitHub,
  llvm,
  rustPlatform,
  stdenvAdapters,
  nix-update-script,
  installShellFiles,
  writeShellApplication,
  lib,
}:
rustPlatform.buildRustPackage.override {
  stdenv = stdenvAdapters.useMoldLinker llvm.stdenv;
} {
  pname = "pinix";
  version = "0-unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "remi-dupre";
    repo = "pinix";
    rev = "7e40521c82b0bdc2886d2e8dee0b53458d889a5b";
    hash = "sha256-B9rr0d0l/y+3u32Iw+pu1ZxUZSnzhj2XLPpN3yhAE+E=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gA5/V0BPNajUcRs6c/Z8YcwiCFADYxmJliii/P6xneY=";

  doCheck = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = let
    wrappers = ["nix" "nix-collect-garbage" "nixos-rebuild" "nix-shell"];
    install-wrappers =
      lib.lists.forEach
      wrappers
      (
        nix-cmd: let
          pix-cmd = "pix" + (lib.strings.removePrefix "nix" nix-cmd);
          pkg = writeShellApplication {
            name = pix-cmd;
            text = ''pinix --pix-command ${nix-cmd} "$@"'';
          };
        in ''
          cat ${pkg}/bin/${pix-cmd} > $out/bin/${pix-cmd}
          chmod +x $out/bin/${pix-cmd}
        ''
      );
  in
    lib.lists.foldl
    (acc: line: acc + "\n" + line) ""
    install-wrappers;

  RUSTFLAGS = "-C link-arg=-fuse-ld=mold";

  updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "A Pacman inspired frontend for Nix";
    homepage = "https://github.com/remi-dupre/pinix";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    mainProgram = "pinix";
  };
}

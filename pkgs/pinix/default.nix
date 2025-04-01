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
  version = "0-unstable-2025-02-20";

  src = fetchFromGitHub {
    owner = "remi-dupre";
    repo = "pinix";
    rev = "72a838e249314d62a17f1f23262d37eb9a5ba7b7";
    hash = "sha256-dl7jXkcMfz0WQct5h/uDKPsGaLw0E2shx/ga4tWJLXI=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-b/I3TEOHEKKmb/1V74G0OW4XTVyFKgsedhCJjm+wg7c=";

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

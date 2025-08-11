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
  version = "0-unstable-2025-08-07";

  src = fetchFromGitHub {
    owner = "remi-dupre";
    repo = "pinix";
    rev = "88181384f67997e009b31b974ccbf45e8f0673ed";
    hash = "sha256-nU9x96DIFr/y/oMetmCrjJ2vtb33oBfZYbNtnFYxRhs=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-UKUZ9GyANdBfd/4dNPcVJUx5kb8HHZK3qMfNcvXieCc=";

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
    broken = true;
  };
}

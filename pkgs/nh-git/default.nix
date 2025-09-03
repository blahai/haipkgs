{
  stdenv,
  lib,
  rustPlatform,
  installShellFiles,
  makeBinaryWrapper,
  fetchFromGitHub,
  nix-update-script,
  nix-output-monitor,
  buildPackages,
}: let
  runtimeDeps = [
    nix-output-monitor
  ];
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "nh-git";
    version = "4.2.0-beta3-unstable-2025-09-02";

    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nh";
      rev = "f3095b9f00092717a694f39a2723fb04e3f575e0";
      hash = "sha256-uNaSFIlyJRsvcMNoN7gxkhr7V6gORtQVUEfFQnwTdWQ=";
    };

    cargoHash = "sha256-ald06MHHSNUo/zGj4nnqXBtMQ6z9+6gcJ+aAmib0dA0=";

    strictDeps = true;

    nativeBuildInputs = [
      installShellFiles
      makeBinaryWrapper
    ];

    postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
      let
        emulator = stdenv.hostPlatform.emulator buildPackages;
      in ''
        mkdir completions

        for shell in bash zsh fish; do
          NH_NO_CHECKS=1 ${emulator} $out/bin/nh completions $shell > completions/nh.$shell
        done

        installShellCompletion completions/*
      ''
    );

    postFixup = ''
      wrapProgram $out/bin/nh \
        --prefix PATH : ${lib.makeBinPath runtimeDeps}
    '';

    passthru.updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };

    env.NH_REV = finalAttrs.src.rev;

    meta = {
      description = "Yet another nix cli helper";
      homepage = "https://github.com/nix-community/nh";
      license = lib.licenses.eupl12;
      mainProgram = "nh";
      maintainers = [];
    };
  })

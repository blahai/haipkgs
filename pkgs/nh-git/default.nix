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
    version = "4.2.0-beta4-unstable-2025-09-05";

    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nh";
      rev = "2b2c678a7c99c81e7f8ad300c25500ef0bf243e7";
      hash = "sha256-pcUB+M2cRod2M2tHfkQziVHpP62Ns5uv/xC2AtX3WfU=";
    };

    cargoHash = "sha256-0MWfZ+/S+SORIih9upcYusLX6CbhXLBTRcFQyDpUiqc=";

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

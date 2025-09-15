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
    version = "4.2.0-unstable-2025-09-14";

    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nh";
      rev = "8bf323483166797a204579a43ed8810113eb128c";
      hash = "sha256-papocgox6HOM+BJrWmWZuRnuDXi625diuC3sajCXd9A=";
    };

    cargoHash = "sha256-cxZsePgraYevuYQSi3hTU2EsiDyn1epSIcvGi183fIU=";

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

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
    version = "4.2.0-unstable-2025-12-05";

    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nh";
      rev = "ef8d8c4cc6904bcd8046eccad9005136abedb19a";
      hash = "sha256-V7lRjvq6vFq0hR4fNYFznahMo/NayVHK18ELKL4Q0To=";
    };

    cargoHash = "sha256-V+Udw9u8PRl3fE/ZFO0zVlrtHC+vXHNAp5pt4QbFVKA=";

    strictDeps = true;

    nativeBuildInputs = [
      installShellFiles
      makeBinaryWrapper
    ];

    postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
    # Run both shell completion and manpage generation tasks. Unlike the
    # fine-grained variants, the 'dist' command doesn't allow specifying the
    # path but that's fine, because we can simply install them from the implicit
    # output directories.
    cargo xtask dist

    # The dist task above should've created
    #  1. Shell completions in comp/
    #  2. The NH manpage (nh.1) in man/
    # Let's install those.
    for dir in comp man; do
      mkdir -p "$out/share/$dir"
      cp -rf "$dir" "$out/share/"
    done
    '';

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

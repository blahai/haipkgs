{
  gtk4,
  gtk4-layer-shell,
  fetchFromGitHub,
  llvm,
  rustPlatform,
  stdenvAdapters,
  nix-update-script,
  rust-bin,
  pkg-config,
  glib,
  gobject-introspection,
  cairo,
  pango,
  gdk-pixbuf,
  lib,
}: let
  nightlyToolchain = rust-bin.selectLatestNightlyWith (toolchain: toolchain.minimal);
in
  rustPlatform.buildRustPackage.override {
    stdenv = stdenvAdapters.useMoldLinker llvm.stdenv;
  } {
    pname = "hyprland-preview-share-picker";
    version = "0.1.0-unstable-2025-02-14";

    src = fetchFromGitHub {
      owner = "WhySoBad";
      repo = "hyprland-preview-share-picker";
      rev = "de915d9c9942221a8e8a8aa476d7ba74a41f0660";
      hash = "sha256-GZ3tP3XruHV9zrHs5rD6FIg0wGbHKgbxQ/81ayptYv4=";
      fetchSubmodules = true;
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-I2dVxRfx0IiXiiLy4ygx5gvtJrf+YHJ4P7Cvq51dIrU=";

    doCheck = false;

    nativeBuildInputs = [
      nightlyToolchain
      glib
      pkg-config
    ];

    buildInputs = [
      cairo
      pango
      gdk-pixbuf
      gobject-introspection
      gtk4
      gtk4-layer-shell
    ];

    rustc = rust-bin.nightly.latest.minimal;
    cargo = rust-bin.nightly.latest.minimal;

    RUSTFLAGS = "-C link-arg=-fuse-ld=mold";

    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };

    meta = {
      description = "An alternative share picker for hyprland with window and monitor previews written in rust. Git version";
      homepage = "https://github.com/WhySoBad/hyprland-preview-share-picker";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  }

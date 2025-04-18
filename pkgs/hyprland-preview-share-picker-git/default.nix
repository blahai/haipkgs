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
    version = "0.2.0-unstable-2025-04-17";

    src = fetchFromGitHub {
      owner = "WhySoBad";
      repo = "hyprland-preview-share-picker";
      rev = "707947c0f9bb34cc4ae92bd9f35d0183dd45a00f";
      hash = "sha256-YXTXXsyTk9QVVahvia2LRggFPBz3bIt5fMDXjJbS8NE=";
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

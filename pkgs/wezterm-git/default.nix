{
  fontconfig,
  installShellFiles,
  lib,
  libGL,
  libxkbcommon,
  llvm,
  ncurses,
  openssl,
  pkg-config,
  python3,
  runCommand,
  rustPlatform,
  stdenvAdapters,
  vulkan-loader,
  wayland,
  xorg,
  zlib,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage.override {stdenv = stdenvAdapters.useMoldLinker llvm.stdenv;} rec {
  pname = "wezterm-git";
  version = "tparse-0.7.0-unstable-2025-06-04";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "wezterm";
    rev = "5106c8c1f799457719ca04f5bd73e7eddaf1de9c";
    hash = "sha256-N9XFuoLcrsZByvKFUFJBmfz/iFOIW0yH15+p9HB/gYI=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uYx5OykWHN4B73rXWMYg3Sl7B+o7uFJMyAFiLMlLCsA=";

  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    python3
  ];

  buildInputs = [
    fontconfig
    zlib
    xorg.libX11
    xorg.libxcb
    libxkbcommon
    openssl
    wayland
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilwm # contains xcb-ewmh among others
  ];

  postPatch = ''
    echo "${version}" > .tag
    # tests are failing with: Unable to exchange encryption keys
    rm -r wezterm-ssh/tests
  '';

  buildFeatures = ["distro-defaults"];

  RUSTFLAGS = "-Clink-arg=-fuse-ld=mold";

  postInstall = ''
    mkdir -p $out/nix-support
    echo "${passthru.terminfo}" >> $out/nix-support/propagated-user-env-packages

    install -Dm644 assets/icon/terminal.png $out/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png
    install -Dm644 assets/wezterm.desktop $out/share/applications/org.wezfurlong.wezterm.desktop
    install -Dm644 assets/wezterm.appdata.xml $out/share/metainfo/org.wezfurlong.wezterm.appdata.xml

    install -Dm644 assets/shell-integration/wezterm.sh -t $out/etc/profile.d
    installShellCompletion --cmd wezterm \
      --bash assets/shell-completion/bash \
      --fish assets/shell-completion/fish \
      --zsh assets/shell-completion/zsh

    install -Dm644 assets/wezterm-nautilus.py -t $out/share/nautilus-python/extensions
  '';

  preFixup = ''
    patchelf \
      --add-needed "${libGL}/lib/libEGL.so.1" \
      --add-needed "${vulkan-loader}/lib/libvulkan.so.1" \
      $out/bin/wezterm-gui
  '';

  passthru = {
    terminfo = runCommand "wezterm-terminfo" {nativeBuildInputs = [ncurses];} ''
      mkdir -p $out/share/terminfo $out/nix-support
      tic -x -o $out/share/terminfo ${src}/termwiz/data/wezterm.terminfo
    '';

    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };
  };

  meta = {
    description = "GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust. Git version";
    homepage = "https://wezfurlong.org/wezterm";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}

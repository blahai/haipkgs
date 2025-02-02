{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron,
  libicns,
  pipewire,
  libpulseaudio,
  autoPatchelfHook,
  pnpm_9,
  nodejs,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vesktop-git";
  version = "1.5.4.r10.gc9be618";

  src = fetchFromGitHub {
    owner = "Vencord";
    repo = "Vesktop";
    rev = "c9be6181644a329ce6556c49186e56e2b7d5e8e2";
    hash = "sha256-amHB9OZUHEqtYBVqr0Fqaj9MnVdNvCexEiOILAL+voo=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit
      (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash = "sha256-yMJ+WZfwbLsnbMO3JI+1KvgfY08JtfDOkN/yEnVQWqA=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    libpulseaudio
    pipewire
    (lib.getLib stdenv.cc.cc)
  ];

  patches = [
    ./disable_update_checking.patch
    ./fix_read_only_settings.patch
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  buildPhase = ''
    runHook preBuild

    pnpm build
    pnpm exec electron-builder \
      --dir \
      -c.asarUnpack="**/*.node" \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  postBuild = ''
    pushd build
    ${libicns}/bin/icns2png -x icon.icns
    popd
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt/Vesktop
    cp -r dist/*unpacked/resources $out/opt/Vesktop/

    for file in build/icon_*x32.png; do
      file_suffix=''${file//build\/icon_}
      install -Dm0644 $file $out/share/icons/hicolor/''${file_suffix//x32.png}/apps/vesktop.png
    done
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/vesktop \
      --add-flags $out/opt/Vesktop/resources/app.asar \
      --add-flags "--enable-blink-features=MiddleClickAutoscroll" \
      --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true"
  '';

  desktopItems = makeDesktopItem {
    name = "vesktop";
    desktopName = "Vesktop";
    exec = "vesktop %U";
    icon = "vesktop";
    startupWMClass = "Vesktop";
    genericName = "Internet Messenger";
    keywords = [
      "discord"
      "vencord"
      "electron"
      "chat"
    ];
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
  };

  passthru = {
    inherit (finalAttrs) pnpmDeps;
    updateScript = nix-update-script {};
  };

  meta = {
    description = "Alternate client for Discord with Vencord built-in. Git version";
    homepage = "https://github.com/Vencord/Vesktop";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      blahai
    ];
    mainProgram = "vesktop";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})

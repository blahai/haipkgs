{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron_37,
  libicns,
  pipewire,
  libpulseaudio,
  autoPatchelfHook,
  pnpm_10,
  nodejs,
  nix-update-script,
}: let
  electron = electron_37;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "vesktop-git";
    version = "1.5.8-unstable-2025-07-11";

    src = fetchFromGitHub {
      owner = "Vencord";
      repo = "Vesktop";
      rev = "27293d4ae9db3a395325f7993cf3cc74a21e0122";
      hash = "sha256-jDZxYrvmaV5VosKM8GPeE6Egevd3qyt5kK5lsHlI6/E=";
    };

    pnpmDeps = pnpm_10.fetchDeps {
      inherit
        (finalAttrs)
        pname
        version
        src
        patches
        ;
      hash = "sha256-dZEaw6sJMYl35aSi2RSxkCf/qo+S0z+m8EjsmgxyiAk=";
      fetcherVersion = "1";
    };

    nativeBuildInputs = [
      nodejs
      pnpm_10.configHook
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
      updateScript = nix-update-script {
        extraArgs = [
          "--version"
          "branch=HEAD"
        ];
      };
    };

    meta = {
      description = "Alternate client for Discord with Vencord built-in. Git version";
      homepage = "https://github.com/Vencord/Vesktop";
      license = lib.licenses.gpl3Only;
      mainProgram = "vesktop";
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  })

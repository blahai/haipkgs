{
  lib,
  fetchFromGitHub,
  stdenv,
  python3,
  makeWrapper,
  runCommand,
  chromium,
  xorg,
  undetected-chromedriver,
  nix-update-script,
  ...
}: let
  python = python3.withPackages (
    p:
      with p; [
        bottle
        waitress
        selenium
        func-timeout
        psutil
        prometheus-client
        requests
        certifi
        packaging
        websockets
        deprecated
        mss
        xvfbwrapper
      ]
  );

  chromium-wrapped = runCommand "chromium-wrapped" {nativeBuildInputs = [makeWrapper];} ''
    mkdir -p $out/bin
    makeWrapper \
      ${chromium}/bin/chromium \
      $out/bin/chromium \
      --add-flags "--disable-gpu"
  '';

  path = lib.makeBinPath [
    chromium-wrapped
    undetected-chromedriver
    xorg.xorgserver
  ];
in
  stdenv.mkDerivation {
    pname = "flaresolverr-21hsmw";
    version = "0-unstable-2025-03-04";
    src = fetchFromGitHub {
      owner = "21hsmw";
      repo = "FlareSolverr";
      rev = "008ff71315baa40761d9d6283a248e50c43db491";
      hash = "sha256-Xf8eXXUV38Yl9fG+ToP0uNqBl+M6JdiRn3rUMltQ3a0=";
    };

    nativeBuildInputs = [makeWrapper];

    postPatch = ''
      substituteInPlace src/utils.py \
        --replace 'PATCHED_DRIVER_PATH = None' 'PATCHED_DRIVER_PATH = "${undetected-chromedriver}/bin/undetected-chromedriver"'
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/opt
      cp -r * $out/opt/

      makeWrapper ${python}/bin/python $out/bin/flaresolverr \
        --add-flags "$out/opt/src/flaresolverr.py" \
        --set PATH "${path}"

      runHook postInstall
    '';

    passthru = {
      updateScript = nix-update-script {
        extraArgs = [
          "--version"
          "branch=HEAD"
        ];
      };
    };

    meta = with lib; {
      mainProgram = "flaresolverr";
      maintainers = with lib.maintainers; [xddxdd];
      description = "Proxy server to bypass Cloudflare protection, with 21hsmw modifications to support nodriver";
      homepage = "https://github.com/21hsmw/FlareSolverr";
      license = licenses.mit;
      # broken = true;
      # Platform depends on chromedriver
      inherit (undetected-chromedriver.meta) platforms;
    };
  }

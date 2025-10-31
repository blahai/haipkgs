{
  lib,
  stdenvNoCC,
  dash,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "app2unit";
  version = "1.1.2-unstable-2025-10-29";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "app2unit";
    rev = "2271a03e75291019dd5717eb403330d90f3ee24e";
    sha256 = "sha256-dXwd51QEoQXQQKMT8scuvcp1qxSwTYUD2bpLj5Bhszs=";
  };

  installPhase = ''
    install -Dt $out/bin app2unit
    ln -s $out/bin/app2unit $out/bin/app2unit-open
  '';

  dontPatchShebangs = true;
  postFixup = ''
    substituteInPlace $out/bin/app2unit \
      --replace-fail '#!/bin/sh' '#!${lib.getExe dash}'
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };
  };

  meta = {
    description = "Launches Desktop Entries as Systemd user units";
    homepage = "https://github.com/Vladimir-csp/app2unit";
    license = lib.licenses.gpl3;
    mainProgram = "app2unit";
    maintainers = with lib.maintainers; [fazzi];
    platforms = lib.platforms.linux;
  };
}

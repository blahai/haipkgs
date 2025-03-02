{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) types;
  cfg = config.haipkgs.overlay;
in {
  options = {
    haipkgs.overlay.enable = mkOption {
      default = true;
      example = false;
      type = types.bool;
      description = ''
        Whether to enable haipkgs overlay.
      '';
    };
  };
  config = {
    nixpkgs.overlays = mkIf cfg.enable [
      inputs.overlays.default
    ];
  };
}

{
  config,
  lib,
  self,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) types;
  cfg = config.haipkgs.cache;
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
      self.overlays.default
    ];
  };
}

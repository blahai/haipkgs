{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkBefore;
  inherit (lib.options) mkOption;
  inherit (lib.types) types;
  cfg = config.haipkgs.cache;
in {
  options = {
    haipkgs.cache.enable = mkOption {
      default = true;
      example = false;
      type = types.bool;
      description = ''
        Whether to enable haipkgs binary cache.
      '';
    };
  };
  config = {
    nix.settings = mkIf cfg.enable {
      substituters = mkBefore ["https://haipkgs.cachix.org"];
      trusted-public-keys = mkBefore [
        "haipkgs.cachix.org-1:AcjMqIafTEQ7dw99RpeTJU2ywNUn1h8yIxz2+zjpK/A="
      ];
    };
  };
}

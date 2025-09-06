let
  modules = {
    haicache = import ./haicache.nix;
    haioverlay = import ./overlay.nix;
  };

  default = {...}: {
    imports = builtins.attrValues modules;
  };
in
  modules // {inherit default;}

let
  modules = {
    refind = import ./refind;
    haicache = import ./haicache.nix;
  };

  default = {...}: {
    imports = builtins.attrValues modules;
  };
in
  modules // {inherit default;}

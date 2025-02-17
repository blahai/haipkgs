let
  modules = {
    refind = import ./refind;
    haicache = import ./haicache.nix;
  };
in
  modules // {default = modules;}

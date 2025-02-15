{lib}: {
  inherit (import ./services.nix {inherit lib;}) mkServiceOption;
}

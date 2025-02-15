{lib}: {
  inherit (import ./services.nix {inherit lib;}) mkServiceOption;
  inherit (import ./programs.nix {inherit lib;}) mkProgram;
  inherit (import ./validators.nix {inherit lib;}) ifTheyExist;
}

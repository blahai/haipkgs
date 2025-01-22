{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    inherit (nixpkgs) lib;

    forAllSystems = fn:
      lib.genAttrs lib.systems.flakeExposed (
        system:
          fn (
            import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
          )
      );
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);
    overlays.default = _: prev: self.packages.${prev.stdenv.hostPlatform.system} or {};
  };
  nixConfig = {
    extra-substituters = ["https://blahai.cachix.org"];
    extra-trusted-public-keys = [
      "blahai.cachix.org-1:7Pg+JDWpcIogeN3HesRnOb4dl6FSwl/ZHC+QUmb65So="
    ];
  };
}

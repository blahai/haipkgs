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
    inherit (lib.attrsets) genAttrs;

    forAllSystems = fn:
      genAttrs ["x86_64-linux" "aarch64-linux"] (
        system:
          fn (
            import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
          )
      );

    mkModule = {
      name ? "default",
      class,
      file,
    }: {
      _class = class;
      _file = "${self.outPath}/flake.nix#${class}Modules.${name}";

      imports = [(import file {haipkgsSelf = self;})];
    };

    loadPackages = pkgs: let
      packageNames = builtins.attrNames (builtins.readDir ./pkgs);
    in
      nixpkgs.lib.genAttrs packageNames (name: pkgs.callPackage (./pkgs + "/${name}") {});

    loadOverlays = let
      overlayNames = builtins.attrNames (builtins.readDir ./overlays);
    in
      nixpkgs.lib.genAttrs overlayNames (name: import (./overlays + "/${name}"));
  in {
    packages = forAllSystems loadPackages;

    hydraJobs = forAllSystems (
      pkgs:
        lib.filterAttrs (
          _: pkg: let
            isDerivation = lib.isDerivation pkg;
            availableOnHost = lib.meta.availableOn pkgs.stdenv.hostPlatform pkg;
            isCross = pkg.stdenv.buildPlatform != pkg.stdenv.targetPlatform;
            broken = pkg.meta.broken or false;
            isCacheable = !(pkg.preferLocalBuild or false);
          in
            isDerivation && (availableOnHost || isCross) && !broken && isCacheable
        )
        self.packages.${pkgs.stdenv.hostPlatform.system}
    );

    nixosModules.default = mkModule {
      class = "nixos";
      file = ./modules/nixos;
    };

    # overlays = loadOverlays;

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        name = "devshell";

        buildInputs = with pkgs; [
          git
          nix-prefetch-git
          jq
        ];

        shellHook = ''
          echo "Entering devshell!"
        '';
      };
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);
  };

  nixConfig = {
    substituters = ["https://nix-community.cachix.org/"];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}

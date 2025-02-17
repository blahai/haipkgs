{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    ...
  }: let
    inherit (nixpkgs) lib;
    inherit (lib.attrsets) genAttrs;
    overlays = [(import rust-overlay)];

    forAllSystems = fn:
      genAttrs ["x86_64-linux" "aarch64-linux"] (
        system:
          fn (
            import nixpkgs {
              inherit system overlays;
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
  in {
    packages = forAllSystems loadPackages;

    overlays = {
      default = _: prev: self.packages.${prev.stdenv.hostPlatform.system} or {};
      inherit (self) haiLib;
    };

    apps = forAllSystems (pkgs: {
      update = {
        type = "app";
        program = lib.getExe (
          pkgs.writeShellApplication {
            name = "update";
            text = lib.concatStringsSep "\n" (
              lib.mapAttrsToList (
                name: pkg:
                  if pkg ? updateScript && (lib.isList pkg.updateScript) && (lib.length pkg.updateScript) > 0
                  then
                    lib.escapeShellArgs (
                      if (lib.match "nix-update|.*/nix-update" (lib.head pkg.updateScript) != null)
                      then
                        [(lib.getExe pkgs.nix-update)]
                        ++ (lib.tail pkg.updateScript)
                        ++ [
                          "--flake"
                          "packages.${pkgs.stdenv.hostPlatform.system}.${name}"
                          "--commit"
                        ]
                      else pkg.updateScript
                    )
                  else builtins.toString pkg.updateScript or ""
              )
              self.packages.${pkgs.stdenv.hostPlatform.system}
            );
          }
        );
      };
    });

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

    haiLib = import ./lib {inherit lib;};

    formatter = forAllSystems (pkgs: pkgs.alejandra);
  };

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org/"
      "https://haipkgs.cachix.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "haipkgs.cachix.org-1:AcjMqIafTEQ7dw99RpeTJU2ywNUn1h8yIxz2+zjpK/A="
    ];
  };
}

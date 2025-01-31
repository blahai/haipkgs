{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    hjem,
    ...
  }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs (import systems) (system: function nixpkgs.legacyPackages.${system});

    loadPackages = pkgs: let
      packageNames = builtins.attrNames (builtins.readDir ./pkgs);
    in
      nixpkgs.lib.genAttrs packageNames (name: pkgs.callPackage (./pkgs + "/${name}") {});

    loadModules = dir: let
      moduleNames = builtins.attrNames (builtins.readDir dir);
    in
      nixpkgs.lib.genAttrs moduleNames (name: import (dir + "/${name}"));

    loadOverlays = let
      overlayNames = builtins.attrNames (builtins.readDir ./overlays);
    in
      nixpkgs.lib.genAttrs overlayNames (name: import (./overlays + "/${name}"));
  in {
    packages = forAllSystems loadPackages;

    nixosModules = loadModules ./modules/nixos;
    hjemModules = loadModules ./modules/hjem;

    overlays = loadOverlays;
  };

  nixConfig = {
    extra-substituters = ["https://blahai.cachix.org" "https://nix-community.cachix.org/"];
    extra-trusted-public-keys = [
      "blahai.cachix.org-1:7Pg+JDWpcIogeN3HesRnOb4dl6FSwl/ZHC+QUmb65So="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    utils.url = "github:numtide/flake-utils";
  };


  outputs = { self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let

        pkgs = import nixpkgs { inherit system; };

      in {
        packages.default = pkgs.callPackage ./package.nix {};
      }
    ) // {

      overlays.default = final: prev: {
        pimd = final.callPackage ./package.nix {};
      };

      nixosModules.default = ./nixosModule;
    };
}

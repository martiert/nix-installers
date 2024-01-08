{
  description = "images for creation";

  inputs = {
    nixpkgs.url = "github:martiert/nixpkgs/devicetree";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    module = {
      url = "github:martiert/nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nixos-generators, module, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (hostSystem:
      {
        packages = {
          x13s-installer = nixos-generators.nixosGenerate rec {
              system = "aarch64-linux";
              modules = [
                module.minimal
                ./installers/x13s
                {
                  nixpkgs.buildPlatform.system = hostSystem;
                  nixpkgs.hostPlatform.system = system;
                }

              ];
              format = "install-iso";
            };
          };
      });
}

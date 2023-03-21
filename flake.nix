{
  description = "images for creation";

  inputs = {
    nixpkgs.url = "github:martiert/nixpkgs/devicetree";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steev-kernel = {
      url = "github:steev/linux/lenovo-x13s";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, nixos-generators, steev-kernel, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (hostSystem:
      {
        packages = {
          aarch64-installer = nixos-generators.nixosGenerate rec {
              system = "aarch64-linux";
              modules = [
                ./installers/aarch64
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

{
  description = "images for creation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ] (system:
      {
        packages = {
          aarch64-installer = let
              system = "aarch64-linux";
            in nixos-generators.nixosGenerate {
              inherit system;
              modules = [
                ./installers/aarch64
                {
                  nixpkgs.buildPlatform.system = "x86_64-linux";
                  nixpkgs.hostPlatform.system = system;
                }
              ];
              format = "install-iso";
            };
        };
      });
}

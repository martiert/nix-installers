{
  description = "images for creation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nixos-generators, ... }@inputs:
    flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ] (system:
      {
        packages = {
          aarch64-installer = nixos-generators.nixosGenerate {
            system = "aarch64-linux";
            modules = [
              ./installers/aarch64
            ];
            format = "install-iso";
          };
        };
      });
}

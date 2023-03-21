{ pkgs, buildLinux, ... }@args:

let
  steev_kernel_pkg = { buildLinux, ... }@args:
   buildLinux (args // rec {
     version = "6.3.0-rc2";
     modDirVersion = version;
     defconfig = ./defconfig;

     src = pkgs.fetchFromGitHub {
       owner = "jhovold";
       repo = "linux";
       rev = "4109f1f560fdbaa9b49f1a09b85c2f9960a8aa54";
       sha256 = "u6z/Yt/sk64/mp1c0o6N7UVrn3YhOyCINtlVH7rYIm0=";
     };
     kernelPatches = [];
   } // (args.argsOverride or {}));
  steev_kernel = pkgs.callPackage steev_kernel_pkg {};
in
  pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor steev_kernel)

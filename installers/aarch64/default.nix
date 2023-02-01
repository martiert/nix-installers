{ pkgs, config, ... }:

let
  dtbName = "sc8280xp-lenovo-thinkpad-x13s.dtb";
  steev_kernel_pkg = { buildLinux, ... }@args:
    buildLinux (args // rec {
      version = "5.19.0";
      modDirVersion = "5.19.0-rc8";

      src = pkgs.fetchFromGitHub {
        owner = "steev";
        repo = "linux";
        rev = "refs/tags/lenovo-x13s-5.19-rc8";
        sha256 = "QfJCAcFV3DtRlvivZrilmZ448QkGgxErkvOp574oh70=";
      };
      kernelPatches = [];
    } // (args.argsOverride or {}));
  steev_kernel = pkgs.callPackage steev_kernel_pkg {};
in {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "dtb=/boot/aarch64/${dtbName}"
  ];
  isoImage.contents = [
    {
      source = "${config.boot.kernelPackages.kernel}/dtbs/qcom/${dtbName}";
      target = "boot/aarch64/${dtbName}";
    }
  ];
  hardware.deviceTree = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  networking.wireless = {
    enable = true;
  };

  system.stateVersion = "23.05";

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '';
}

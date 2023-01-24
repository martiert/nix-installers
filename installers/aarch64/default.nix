{ pkgs, config, ... }:

let
  dtbName = "sc8280xp-lenovo-thinkpad-x13s.dtb";
in {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.zfs.enableUnstable = true;
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
    git-crypt
    gnupg
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "tty";
  };

  networking.wireless = {
    enable = true;
  };

  environment.etc."gnupg/keys.pub".source = ../../settings/home-manager/keys.pub;

  environment.loginShellInit = ''
    ${pkgs.gnupg}/bin/gpg --import /etc/gnupg/keys.pub
  '';

  system.stateVersion = "22.05";

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '';
}

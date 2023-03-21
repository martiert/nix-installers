{ pkgs, lib, config, ... }:

let
  dtbName = "sc8280xp-lenovo-thinkpad-x13s.dtb";
  firmware = pkgs.callPackages ./firmware {};
in {
  boot.kernelPackages = pkgs.callPackage ./kernel {};
  boot.kernelParams = [
    "efi=novamap,noruntime"
    "pd_ignore_unused"
    "clk_ignore_unused"
    "loglevel=3"
  ];
  nixpkgs.overlays = [(final: super: {
    zfs = super.zfs.overrideAttrs(_: {
      meta.platforms = [];
    });
  })];
  boot.initrd.kernelModules = [
    "nvme"
    "phy_qcom_qmp_pcie"
    "pcie_qcom"
    "i2c_hid_of"
    "i2c_qcom_geni"
    "leds_qcom_lpg"
    "pwm_bl"
    "qrtr"
    "pmic_glink_altmode"
    "gpio_sbu_mux"
    "phy_qcom_qmp_combo"
    "panel-edp"
    "msm"
    "phy_qcom_edp"
  ];
  isoImage = {
    makeUsbBootable = false;
    makeEfiBootable = true;
    contents = [
      {
        source = "${config.boot.kernelPackages.kernel}/dtbs";
        target = "boot/dtbs";
      }
    ];
  };
  hardware = {
    enableAllFirmware = false;
    enableRedistributableFirmware = lib.mkForce false;
    deviceTree = {
      enable = true;
    };
    firmware = [
      pkgs.linux-firmware
      firmware.aarch64-firmware
    ];
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  system.stateVersion = "23.05";

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '';
}

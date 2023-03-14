{ pkgs, config, ... }:

let
  dtbName = "sc8280xp-lenovo-thinkpad-x13s.dtb";
in {
  boot.kernelPatches = [
    {
      name = "Disable PCI DMA";
      patch = null;
      extraConfig = ''
        CONFIG_EFI_DISABLE_PCI_DMA y
        CONFIG_EFI_STUB y
        CONFIG_EFI_GENERIC_STUB y
        CONFIG_EFI_ARMSTUB_DTB_LOADER y
      '';
    }
  ];
  boot.kernelParams = [
    "efi=novamap"
    "pd_ignore_unused"
    "clk_ignore_unused"
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
  hardware.deviceTree = {
    enable = true;
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

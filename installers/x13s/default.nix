{ pkgs, lib, config, modulesPath, ... }:

{
  nixpkgs.overlays = [(final: super: {
    zfs = super.zfs.overrideAttrs(_: {
      meta.platforms = [];
    });
    upower = super.upower.overrideAttrs(_: {
      doCheck = false;
    });
  })];

  martiert.system = {
    type = "laptop";
    aarch64.arch = "sc8280xp";
  };
  boot.supportedFilesystems = lib.mkForce [
    "ext4"
  ];

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

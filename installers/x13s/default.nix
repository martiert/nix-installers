{ pkgs, lib, config, ... }:

let
  dtbName = "sc8280xp-lenovo-thinkpad-x13s.dtb";
  firmware = pkgs.callPackages ./firmware {};
in {
  martiert = {
    type = "laptop";
    aarch64.arch = "sc8280xp";
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

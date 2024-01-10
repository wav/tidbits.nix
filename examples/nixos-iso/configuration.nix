{ config, pkgs, inputs, ... }:

let
  user = "nixos";
in
{
  imports = [
    ./hardware-configuration.nix
    # "inputs.tidbits.nixosModules.default"
    inputs.tidbits.nixosModules.default
    inputs.home-manager.nixosModules.default
  ];

  # "inputs.tidbits.overlays.default"
  tidbits.display-scaling.enable = true;

  users.users.${user} = {
    group = user;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  users.groups.${user} = { };

  home-manager.users.${user} = import ./home-manager.nix;

  system.stateVersion = "23.11";
}

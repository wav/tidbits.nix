{
  description = ''tidbits'';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      forAllSystems = systems: f: nixpkgs.lib.genAttrs systems (system: f system);
      inputs-overlay = (_: _: { tidbits.inputs = { inherit home-manager; }; });
      overlays = [
        inputs-overlay
        (import ./overlay.nix)
      ];
    in
    {
      nixosModules.default = {
        imports = [ ./modules/nixos ];
        nixpkgs.overlays = overlays;
      };

      packages = forAllSystems [ "aarch64-darwin" "x86_64-linux" "aarch64-linux" ]
        (system:
          let
            pkgs = (import nixpkgs { inherit system overlays; });
          in
          pkgs.tidbits);

      inherit ((import ./examples/nixos-iso/flake.nix).outputs (inputs // { tidbits = self; })) nixosConfigurations;

      assertions =
        let
          cfg = self.nixosConfigurations.nixos-iso.config;
          usrCfg = cfg.home-manager.users.nixos;
        in
        [
          {
            assertion = cfg.tidbits.display-scaling.cursor-size == 24;
            message = "system attribute 'tidbits.display-scaling.cursor-size != 24'";
          }
          {
            assertion = usrCfg.tidbits.display-scaling.cursor-size == 36;
            message = "home attribute 'tidbits.display-scaling.cursor-size != 36'";
          }
          {
            assertion = usrCfg.dconf.settings."org/gnome/desktop/interface".scaling-factor.value == 1.25;
            message = "home attribute 'dconf.settings.\"org/gnome/desktop/interface\".scaling-factor != 1.25'";
          }
        ];

    };
}

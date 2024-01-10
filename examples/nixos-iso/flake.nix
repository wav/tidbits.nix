{
  description = "tidbits.nix example";

  inputs = {
    tidbits.url = "github:wav/tidbits.nix/main";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    {
      nixosConfigurations.nixos-iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
        ];
      };
    };
}

## Using a `configuration.nix` with a flake.

In your own `flake.nix`, build a `nixosSystem` configuration similar to [./flake.nix](./flake.nix)

Then in the flake directory, run `nixos-rebuild switch --flake .`

For convenience, assuming:
- your configuration resides in `/nix-config`
- and your `flake.nix` has an `output` matching your hostname, like `nixosConfiguration.${hostname}`

Create an alias for your shell like the following:

`alias update-system=sudo nixos-rebuild switch --flake "/nix-config#$(hostname -s)"'`

There after you can call `update-system`.

This alias can be put in your `home-manager.nix` configuration, at:

`programs.zsh.shellAliases.update-system = "sudo nixos-rebuild ...`

or

`programs.bash.shellAliases.update-system = "sudo nixos-rebuild ...`
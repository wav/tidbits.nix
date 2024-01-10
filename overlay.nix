final: prev:

let
  # extend pkgs.lib with yants, hm (home manager) and tidbits.*
  lib =
    let
      sources = import ./sources.nix { inherit (final) fetchgit; };
    in
    import ./lib/f/mergeLibsInOrder.nix "tidbits" prev [
      (pkgs: {
        yants = import "${sources.yants}/default.nix" { inherit (pkgs) lib; };
        hm = import "${pkgs.tidbits.inputs.home-manager}/modules/lib" { inherit (pkgs) lib; };
      })
      (pkgs:
        assert builtins.hasAttr "tidbits" pkgs.lib;
        {
          templating = import ./lib/templating.nix { inherit pkgs; };
          packaging = import ./lib/packaging.nix { inherit pkgs; };
        })
    ];

  tidbits = import ./lib/f/collectPackagesInPath.nix lib final.callPackage ./pkgs;
in
{
  inherit lib tidbits;
}

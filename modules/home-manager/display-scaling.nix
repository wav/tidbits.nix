{ config, lib, pkgs, osConfig, ... }:

let
  inherit (pkgs.stdenv) isDarwin;

  cfg = config.tidbits.display-scaling;
  osCfg = osConfig.tidbits.display-scaling;
in
{
  options.tidbits.display-scaling = with lib.types;
    let
      inherit (lib) mkOption;
    in
    {
      # in gnome, for now, you may need to set "Settings > Displays > Scale = 125%" manually
      enable = mkOption {
        type = bool;
        default = osCfg.enable;
      };

      DPI = mkOption {
        type = float;
        # res   : 3840 X 2160
        # size  : 26.95"
        # dpi   = 163.48
        # pitch = 0.1554 x 0.1554
        default = osCfg.DPI;
      };

      scaling-factor = mkOption {
        type = float;
        # At 1.25 is a threshold upon which firefox chooses a larger font style that looks so much crisper.
        default = osCfg.scaling-factor;
      };

      cursor-size = mkOption {
        type = int;
        default = osCfg.cursor-size;
      };

    };

  config = lib.mkIf (cfg.enable && !pkgs.stdenv.isDarwin)
    (
      let
        inherit (builtins) toString floor;
        inherit (pkgs.lib.tidbits.hm.gvariant) mkDouble;

        # example:  (163.48 / 163) * 1.25 = 1.254
        text-scaling-factor = (cfg.DPI / (floor cfg.DPI)) * cfg.scaling-factor;
        scaled-cursor-size = (cfg.cursor-size * cfg.scaling-factor);
        font-hinting = "full"; # slight|full;
        settings = {
          "org/gnome/desktop/interface" = {
            scaling-factor = mkDouble cfg.scaling-factor;
            text-scaling-factor = mkDouble text-scaling-factor;
          };
        };
      in
      {
        dconf = { inherit settings; };
        home.pointerCursor = {
          name = "Vanilla-DMZ";
          package = pkgs.vanilla-dmz;
          size = floor scaled-cursor-size;
          x11.enable = true;
        };
      }
    );
}

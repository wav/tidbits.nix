{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv) isDarwin;

  cfg = config.tidbits.display-scaling;
in
{
  options.tidbits.display-scaling = with lib.types;
    let
      inherit (lib) mkOption mkEnableOption;
    in
    {
      # in gnome, for now, you may need to set "Settings > Displays > Scale = 125%" manually
      enable = mkEnableOption "apply display scaling";

      DPI = mkOption {
        type = float;
        # res   : 3840 X 2160
        # size  : 26.95"
        # dpi   = 163.48
        # pitch = 0.1554 x 0.1554
        default = 163.48;
      };

      scaling-factor = mkOption {
        type = float;
        # At 1.25 is a threshold upon which firefox chooses a larger font style that looks so much crisper.
        default = 1.25;
      };

      cursor-size = mkOption {
        type = int;
        default = 24;
      };

    };

  config = lib.mkIf (!pkgs.stdenv.isDarwin)
    (
      let
        inherit (builtins) toString floor;
        scaled-cursor-size = (cfg.cursor-size * cfg.scaling-factor);
      in
      {

        services.xserver.dpi = floor cfg.DPI;

        environment.variables = {
          # this affects discord/slack/jetbrains window borders
          GDK_SCALE = "1";
          # this affects discord
          XCURSOR_SIZE = "${toString scaled-cursor-size}";
          GDK_DPI_SCALE = "${toString ((floor cfg.DPI) / 96)}";
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        };

        services.xserver.desktopManager.gnome = {
          extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
          # enables "125%" option in "Settings > Displays > Scale"
          extraGSettingsOverrides = ''
            [org.gnome.mutter]
            experimental-features=['scale-monitor-framebuffer']
          '';
        };

      }
    );
}

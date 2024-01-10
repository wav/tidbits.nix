{ pkgs }:

with builtins;
with pkgs.lib.tidbits.yants;

let
  inherit (pkgs) lib;

  urlShortcut = struct "urlShortcut" {
    icon = path;
    url = string;
  };
in
{
  # ./.local/share/applications/${name}.desktop
  # /run/current-system/sw/share/applications/${name}.desktop
  urlShortcut =
    defun [ string urlShortcut drv ] (name: { url, icon }:
      pkgs.writeTextFile {
        name = "${name}.desktop";
        destination = "/share/applications/${name}.desktop";
        text = ''
          [Desktop Entry]
          Name=${name}
          Comment=Play this game on Steam
          Exec=xdg-open ${url}
          Icon=${icon}
          Terminal=false
          Type=Application
        '';
      });

}

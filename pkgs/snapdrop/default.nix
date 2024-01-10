{ pkgs, ... }:

pkgs.lib.tidbits.packaging.urlShortcut "Snapdrop" {
  url = "https://snapdrop.net/";
  icon = ./snapdrop-128.ico;
}

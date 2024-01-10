{ osConfig, ... }: {
  home.stateVersion = osConfig.system.stateVersion;
  manual.manpages.enable = false;
  tidbits.display-scaling.cursor-size = 36;
}

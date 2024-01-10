{ pkgs, ... }: {

  home-manager = {
    # useGlobalPkgs so that our overlays are available
    useGlobalPkgs = true;
    sharedModules = (import ../home-manager).imports;
  };

}

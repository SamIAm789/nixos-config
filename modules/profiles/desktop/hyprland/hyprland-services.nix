{
  flake.modules.homeManager.hyprlandServices = {

    services = {
      cliphist.enable = true;
      hyprpolkitagent.enable = true;
      network-manager-applet.enable = true;
      udiskie.enable = true;
    };
  };
}

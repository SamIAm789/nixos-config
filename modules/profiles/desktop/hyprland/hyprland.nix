{
  inputs,
  ...
}:
{
  flake.modules.nixos.hyprland =
    {
      pkgs,
      ...
    }:
    {

    # start hyprland with "uwsm start hyprland desktop"

      programs.hyprland = {
        enable = true;
        withUWSM = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };

      #screensharing
      #xdg.portal = {
      #  enable = true;
      #  extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
      #};

      services = {
        upower.enable = true;
        tlp.enable = true;
      };

      # general desktop optimisations
      services.dbus.implementation = "broker";
      # networking.networkmanager.wifi.backend = "iwd";

      services.flatpak.enable = true;

      fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };
}

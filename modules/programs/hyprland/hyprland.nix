{
  inputs,
  ...
}:
{

  flake-file.inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
  };

  flake.modules.nixos.hyprland =
    {
      pkgs,
      ...
    }:
    {

      imports =
        with inputs.self.modules.nixos;
        [
          ashell
          fuzzel
          hypridle
          hyprlock
          wpaperd
        ]
        ++ (with inputs.self.modules.homeManager; [
          hyprland
          ashell
          fuzzel
          hypridle
          hyprlock
          wpaperd
        ]);

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

      # networking.networkmanager.wifi.backend = "iwd";

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };
}

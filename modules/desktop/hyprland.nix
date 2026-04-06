{ self, inputs, ... }: {

  flake.nixosodules.hyperland = { config, lib, pkgs, ... }: {
    with lib;
    let
      cfg = config.myOptions.hyprland;
    in {

      options = {
        myOptions.hyprland.enable = mkEnableOption "enables hyprland desktop environment";
      };

      imports = [
        self.nixosModules.polkit
      ];

      config = mkIf cfg.enable {

        programs.hyprland = {
          enable = true;
          withUWSM = true;
          package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        };

        # services.displayManager.gdm.enable = true;

        environment.systemPackages = with pkgs; [
          kitty
          swaynotificationcenter
          nautilus
          bolt
          bluetuith
        ];

        programs.kdeconnect.enable = true;

        services = {
          pipewire.enable = true;
          upower.enable = true;
          hardware.bolt.enable = true;
          tlp.enable = true;
        };

        # general desktop optimisations
        services.dbus.implementation = "broker";

        hardware.bluetooth.enable = true;

        services.flatpak.enable = true;

        # needed for hyprlock
        security.pam.services.hyprlock = {};

        fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

        environment.sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };

        home-manager.users.sam = {
          imports = [
            ../../home/hyprland/hyprland.nix
          ];
        };

        nix.settings = {
          substituters = ["https://hyprland.cachix.org"];
          trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        };
      };
    }
  }
}

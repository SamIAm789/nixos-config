{
  flake.modules.nixos.hyprland = {

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
      #hyprpolkitagent
      nautilus
      bolt
      bluetuith

    ];

    #programs.ssh.startAgent = true;

    programs.kdeconnect.enable = true;

    #screensharing
    #xdg.portal = {
    #  enable = true;
    #  extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    #};

    services = {
      pipewire.enable = true;
      upower.enable = true;
      hardware.bolt.enable = true;
      tlp.enable = true;
    };

    # general desktop optimisations
    services.dbus.implementation = "broker";
    # networking.networkmanager.wifi.backend = "iwd";

    hardware.bluetooth.enable = true;

    services.flatpak.enable = true;

    fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

# needed for hyprlock
    security.pam.services.hyprlock = {};

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
     
  }

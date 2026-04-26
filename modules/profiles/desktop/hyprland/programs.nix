{
  flake.modules.nixos.desktopPrograms = {
    environment.systemPackages = with pkgs; [
      kitty
      swaynotificationcenter
      #hyprpolkitagent
      nautilus
      bluetuith
    ];

    programs.kdeconnect.enable = true;
  }
}
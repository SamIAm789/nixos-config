{
  flake.modules.nixos.desktopPrograms =
  {
    pkgs,
    ...
  }:
  {

    environment.systemPackages = with pkgs; [
      kitty
      swaynotificationcenter
      nautilus
      bluetuith
    ];

    programs.kdeconnect.enable = true;
  };
}

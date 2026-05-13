{
  flake.modules.nixos.hyprland =
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
  };
}

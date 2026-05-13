{
  flake.modules.nixos.hyprland =
  {
    pkgs,
    ...
  }:
  {
    fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  };
}

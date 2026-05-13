{
  flake.modules.nixos.hyprland = {
    fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  };
}

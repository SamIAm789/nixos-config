{
  inputs,
  ...
}:
{
  flake.modules.homeManager.hyprland = {

    imports = with inputs.self.modules.homeManager; [
      hyprland
      ashell
      fuzzel
      hypridle
      hyprlock
      wpaperd
    ];
  };
}

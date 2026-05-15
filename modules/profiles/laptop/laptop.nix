{
  inputs,
  ...
}:
{
  flake.modules.nixos.laptop = {
    imports = with inputs.self.modules.nixos; [
      base
      general-desktop
<<<<<<< HEAD
=======
      hardware
      hyprland
>>>>>>> 2e5b22e (flake-parts)
    ];
  };
}

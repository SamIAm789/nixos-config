{
  inputs,
  ...
}:
{
  flake.modules.nixos.laptop = {
    imports = with inputs.self.modules.nixos; [
      base
      general-desktop
    ];
  };
}

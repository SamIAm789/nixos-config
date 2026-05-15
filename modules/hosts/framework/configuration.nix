{
  inputs,
  ...
}:
{

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "framework";

  flake.modules.nixos.framework = {
    imports = with inputs.self.modules.nixos; [
      framework-hardware
      base
<<<<<<< HEAD
      hyprland
=======
      laptop
>>>>>>> 2e5b22e (flake-parts)
    ];

    services.fprintd.enable = true;

    environment.systemPackages = with pkgs; [
      scrcpy
      vlc
    ];

    system.stateVersion = "25.05";
  };
}

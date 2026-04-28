{
  flake.modules.nixos.polkit = {

    environment.systemPackages = [
      pkgs.hyprpolkitagent
    ];

    security.polkit.enable = true;
  };
}
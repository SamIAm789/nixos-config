{ self, inputs, ... }: {

  flake.nixosModules.polkit = { pkgs, lib, ... }: {

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.hyprland.enableGnomeKeyring = true;
    security.polkit.enable = true;

  }
}

{
  inputs,
  ...
}:
{
  flake.modules.nixos.general-desktop = {
    imports = with inputs.self.modules.nixos; [
      dbus
      firefox
      flatpak
      hardware
      kdeconnect
      pipewire
      power-management
      ssh-agent
      zed
    ];
  };
}

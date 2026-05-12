{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.general-desktop = {
    imports = with inputs.self.modules.nixos; [
      firefox
      hardware
      kdeconnect
      pipewire
      ssh-agent
      zed
    ];
  };
}

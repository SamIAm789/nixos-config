{
  flake.modules.nixos.hardware = {
    hardware.bluetooth.enable = true;
    services.hardware.bolt.enable = true;
  };
}
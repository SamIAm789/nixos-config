{
  flake.modules.nixos.network =
  {
    lib,
    ...
  }:
  {
    networking = {
      nftables.enable = true;
      networkmanager.enable = lib.mkForce false;
      useDHCP = false;
    };
    systemd.network.enable = true;
  };
}

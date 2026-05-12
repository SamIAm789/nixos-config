{
  flake.modules.nixos.network = {
    networking = {
      nftables.enable = true;
      useDHCP = false;
    };
    systemd.network.enable = true;
  };
}

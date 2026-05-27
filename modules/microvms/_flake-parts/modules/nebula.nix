{
  flake.modules.nixos.nebula =
  {
    pkgs,
    ...
  }:
  {
    # Ensure the mount exists before nebula starts
    systemd.tmpfiles.rules = [
      "d /run/secrets/nebula 0750 root root -"
    ];

    environment.systemPackages = [ pkgs.nebula ];

    services.nebula.networks.pertaka = {
      ca   = /run/secrets/nebula/ca.crt;
      cert = /run/secrets/nebula/host.crt;
      key  = /run/secrets/nebula/host.key;

      staticHostMap = {
        "100.100.0.1" = [ "161.33.225.147:4242" ];
      };

      lighthouses = [ "100.100.0.1" ];

      settings = {
        lighthouse = {
          am_lighthouse = false;
          interval = 60;
        };

        punchy = {
          punch = true;
          respond = true;
        };
      };

      firewall = {
        outbound = [
          { host = "any"; port = "any"; proto = "any"; }
        ];
        inbound = [
          { host = "any"; port = "any"; proto = "any"; }
        ];
      };

      relays = [ "100.100.0.1" ];
    };
  };
}

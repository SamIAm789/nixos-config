{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.microvm-host =
  {
    config,
    lib,
    ...
  }:
  let
    hostname = config.networking.hostName;
    hash = builtins.hashString "sha256" hostname;

    # take 6 bytes = 12 hex chars
    raw = builtins.substring 0 12 hash;

    mac =
      "02:" +
      (builtins.substring 0 2 raw) + ":" +
      (builtins.substring 2 2 raw) + ":" +
      (builtins.substring 4 2 raw) + ":" +
      (builtins.substring 6 2 raw) + ":" +
      (builtins.substring 8 2 raw);

  in
  {
    imports = [
      inputs.microvm.nixosModules.host
    ];

    microvm.host.enable = true;

    networking = {
      networkmanager.enable = lib.mkForce false;
      useDHCP = false;
    };

    systemd.network = {
      enable = true;

      netdevs = {

        "10-microbr" = {
          netdevConfig = {
            Kind = "bridge";
            Name = "microbr";
            MACAddress = mac;
          };
        };
      };

      networks = {

        "12-lan" = {
          matchConfig.Name = [ "eno1" "vm-*" ];
          networkConfig.Bridge = "microbr";
          linkConfig.RequiredForOnline = "enslaved";
        };
    
        "13-lan-microbr" = {
          matchConfig.Name = "microbr";
          bridgeConfig = {};
          linkConfig.RequiredForOnline = "routable";
          networkConfig.DHCP = "yes";
        };
      };

      links = {

        "11-lan-microbr" = {
          matchConfig.Name = "microbr";
          linkConfig = {};
        };
      };
    };
  };
}

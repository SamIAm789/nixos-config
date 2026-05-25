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
    lib,
    ...
  }:
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
            MACAddress = "none";
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
          linkConfig = {
            MACAddressPolicy = "none";
          };
        };
      };
    };
  };
}

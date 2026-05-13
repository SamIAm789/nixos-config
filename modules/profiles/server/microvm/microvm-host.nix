{
  flake-file.inputs = {
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.microvm-host.nix =
  {
    lib,
    ...
  }:
  {
    microvm.host.enable = true;

    networking = {
      networkmanager.enable = lib.mkForce false;
      useDHCP = false;
    };

    systemd.network = {
      enable = true;

      netdevs = {

        "microbr" = {
          netdevConfig = {
            Kind = "bridge";
            Name = "microbr";
          };
        };
      };

      networks = {

        "10-lan" = {
          matchConfig.Name = [ "eno1" "vm-*" ];
          networkConfig.Bridge = "microbr";
          linkConfig.RequiredForOnline = "enslaved";
        };

        "10-lan-microbr" = {
          matchConfig.Name = "microbr";
          linkConfig = {
            RequiredForOnline = "routable";
          };
          networkConfig = {
            DHCP = "yes";
          };
        };
      };
    };
  };
}

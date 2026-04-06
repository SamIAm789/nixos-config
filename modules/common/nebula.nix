{ self, inputs, ... }: {

  flake.nixosModules.nebula = { config, lib, pkgs, sops-nix, ... }:

  let
    host = config.networking.hostName;
    nebulaSecrets = [
      "ca_crt"
      "backup-server_crt"
      "backup-server_key"
      "framework_crt"
      "framework_key"
      "haos_crt"
      "haos_key"
      "server_crt"
      "server_key"
    ];

  in {

    options = {
      myOptions.nebula = lib.mkEnableOption "enables nebula networking";
    };

    config = lib.mkIf config.myOptions.nebula {

      environment.systemPackages = [
        pkgs.nebula
      ];

      sops.secrets =
    builtins.listToAttrs (map (name: {
      name = "nebula_${name}";
      value = {
        sopsFile = ../../secrets/nebula.yaml;
        owner = "nebula-pertaka";
        group = "nebula-pertaka";
        mode = "0400";
      };
    }) nebulaSecrets);

      services.nebula.networks.pertaka = {
        ca = config.sops.secrets."nebula_ca_crt".path;
        cert = config.sops.secrets."nebula_${host}_crt".path;
        key = config.sops.secrets."nebula_${host}_key".path;
        staticHostMap = {
          "100.100.0.1" = [ "161.33.225.147:4242" ];
        };
        lighthouses = [ "100.100.0.1" ];
        settings = {
          punchy = {
            punch = true;
            respond = true;
          };
        };
        firewall = {
          outbound = [
            {
              host = "any";
              port = "any";
              proto = "any";
            }
          ];
          inbound = [
            {
              host = "any";
              port = "any";
              proto = "any";
            }
          ];
        };
        relays = [
          "100.100.0.1"
        ];
      };
    };
  };
}

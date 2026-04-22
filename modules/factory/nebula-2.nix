
# nix/aspects/nebula.nix
{ lib, ... }:
{
  config.flake.factory.nebula-host =
    { isLighthouse ? false
    , secretsPrefix ? "nebula"
    }:

    { config, pkgs, ... }:

    let
      # Hostname from system config
      host = config.networking.hostName;

      # Hardcoded network + port
      networkName = "pertaka";
      listenPort = 4242;

      # SOPS file from private repo
      sopsFile = /secrets/nebula.yaml;

      # Nebula user/group
      nebulaUser = "nebula-pertaka";
      nebulaGroup = "nebula-pertaka";

      # List of secrets exactly like your working module
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

      # Helper to get a secret path
      secretPath = name:
        config.sops.secrets."nebula_${name}".path;

      # Lighthouse IP stored in SOPS and read as a literal string
      lighthouseIP =
        builtins.readFile
          config.sops.secrets."nebula_lighthouse_ip".path;

    in
    {
      # --- SOPS secrets (same as your module, but generated) ---
      sops.secrets =
        builtins.listToAttrs (map (name: {
          name = "nebula_${name}";
          value = {
            inherit sopsFile;
            owner = nebulaUser;
            group = nebulaGroup;
            mode = "0400";
          };
        }) nebulaSecrets)
        //
        {
          # Lighthouse IP secret
          nebula_lighthouse_ip = {
            inherit sopsFile;
            owner = nebulaUser;
            group = nebulaGroup;
            mode = "0400";
          };
        };

      # --- Nebula service ---
      services.nebula.networks.${networkName} = {
        ca   = secretPath "ca_crt";
        cert = secretPath "${host}_crt";
        key  = secretPath "${host}_key";

        # Static host map always includes lighthouse
        staticHostMap = {
          "100.100.0.1" = [ lighthouseIP ];
        };

        # Non-lighthouse nodes point to lighthouse
        lighthouses =
          lib.mkIf (!isLighthouse) [ "100.100.0.1" ];

        settings = {
          lighthouse = {
            am_lighthouse = isLighthouse;
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

        relays =
          lib.mkIf (!isLighthouse) [ "100.100.0.1" ];
      };

      # Nebula binary
      environment.systemPackages = [ pkgs.nebula ];
    };
}
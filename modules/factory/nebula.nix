
{
  config.flake.factory.nebula-host =
    { isLighthouse ? false }:

    { config, lib, pkgs, inputs, ... }:

    let
      host = config.networking.hostName;
      networkName = "pertaka";
      listenPort = 4242;

      sopsFile = "${inputs.secrets}/secrets/nebula.yaml";

      nebulaUser = "nebula-pertaka";
      nebulaGroup = "nebula-pertaka";

      # Helper to get a secret path
      secret = name:
        config.sops.secrets."nebula/${name}".path;

      # Lighthouse IP stored in SOPS and read as a literal string
      lighthouseIP =
        builtins.readFile
          config.sops.secrets."nebula_lighthouse_ip".path;

    in
    {
     # --- SOPS secrets ---
      sops.secrets = {
        "nebula/ca" = {
          inherit sopsFile;
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };

        "nebula/${host}/cert" = {
          inherit sopsFile;
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };

        "nebula/${host}/key" = {
          inherit sopsFile;
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };

        "nebula/lighthouse_ip" = {
          inherit sopsFile;
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };
      };

      # --- Nebula service ---
      services.nebula.networks.${networkName} = {
        ca   = secret "ca";
        cert = secret "${host}/cert";
        key  = secret "${host}/key";

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

      environment.systemPackages = [ pkgs.nebula ];
    };
}

# nix/aspects/nebula.nix
{ lib, ... }:
{
  config.flake.factory.nebula-host =
    { hostName
    , isLighthouse ? false
    , secretsPrefix ? "nebula"
    , sopsFile
    }:

    { config, pkgs, ... }:

    let
      networkName = "pertaka";
      listenPort = 4242;

      # host-specific secret path helper
      secret = name:
        config.sops.secrets."${secretsPrefix}/${hostName}/${name}".path;

      # lighthouse IP must be read as a string
      lighthouseIP =
        builtins.readFile
          config.sops.secrets."${secretsPrefix}/lighthouse/ip".path;

    in
    {
      # --- SOPS secrets ---
      sops.secrets = {
        "${secretsPrefix}/${hostName}/ca"      = { inherit sopsFile; };
        "${secretsPrefix}/${hostName}/cert"    = { inherit sopsFile; };
        "${secretsPrefix}/${hostName}/key"     = { inherit sopsFile; };
        "${secretsPrefix}/${hostName}/hostmap" = { inherit sopsFile; };

        # shared lighthouse IP secret
        "${secretsPrefix}/lighthouse/ip" = {
          inherit sopsFile;
          owner = "root";
          mode = "0400";
        };
      };

      # --- Nebula service ---
      services.nebula = {
        enable = true;

        networks.${networkName} = {
          enable = true;

          ca   = secret "ca";
          cert = secret "cert";
          key  = secret "key";

          staticHostMapFile = secret "hostmap";

          listen = {
            host = "0.0.0.0";
            port = listenPort;
          };

          lighthouse = {
            amLighthouse = isLighthouse;
            interval = 60;

            hosts = lib.optionals (!isLighthouse) [
              lighthouseIP
            ];
          };
        };
      };
    };
}
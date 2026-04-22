{
  config.flake.factory.nebula-host =
    { isLighthouse ? false }:

    { config, pkgs, ... }:

    let
      # Hostname from system config
      hostName = config.networking.hostName;

      # Hardcoded network + port
      networkName = "pertaka";
      listenPort = 4242;

      # Shared SOPS file from private repo
      sopsFile = "${inputs.secrets}/secrets/nebula.yaml";

      # Helper for host-specific secrets
      secret = name:
        config.sops.secrets."${secretsPrefix}/${hostName}/${name}".path;

      # Lighthouse IP must be read as a literal string
      lighthouseIP =
        builtins.readFile
          config.sops.secrets."${secretsPrefix}/lighthouse/ip".path;

      # Nebula user/group
      nebulaUser = "nebula";
      nebulaGroup = "nebula";

    in
    {
      # --- SOPS secrets ---
      sops.secrets = {
        # Host certs
        "${secretsPrefix}/${hostName}/ca" = {
          inherit sopsFile;
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };

        "${secretsPrefix}/${hostName}/cert" = {
          inherit sopsFile;
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };

        "${secretsPrefix}/${hostName}/key" = {
          inherit sopsFile;
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };

        "${secretsPrefix}/${hostName}/hostmap" = {
          inherit sopsFile;
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };

        # Shared lighthouse IP secret
        "${secretsPrefix}/lighthouse/ip" = {
          inherit sopsFile;
          owner = nebulaUser;
          group = nebulaGroup;
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

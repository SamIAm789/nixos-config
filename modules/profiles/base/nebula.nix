{
  inputs,
  ...
}:
{
  flake.modules.nixos.nebula =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      host = config.networking.hostName;
      isLighthouse = host == "lighthouse";
      sopsFile = "${inputs.secrets}/secrets/nebula.yaml";
      nebulaUser = "nebula-pertaka";
      nebulaGroup = "nebula-pertaka";
      lighthouseIP = "161.33.225.147:4242";

    in
    {

      environment.systemPackages = [ pkgs.nebula ];

      # --- SOPS secrets ---
      sops.secrets = {
        "nebula.ca" = {
          inherit sopsFile;
          key = "nebula/ca";
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };

        "nebula.${host}.crt" = {
          inherit sopsFile;
          key = "nebula/${host}/crt";
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };

        "nebula.${host}.key" = {
          inherit sopsFile;
          key = "nebula/${host}/key";
          owner = nebulaUser;
          group = nebulaGroup;
          mode = "0400";
        };
      };

      services.nebula.networks.pertaka = {
        ca   = config.sops.secrets."nebula.ca".path;
        cert = config.sops.secrets."nebula.${host}.crt".path;
        key  = config.sops.secrets."nebula.${host}.key".path;

        staticHostMap = lib.mkIf (!isLighthouse) {
          "100.100.0.1" = [ lighthouseIP ];
        };

        lighthouses = lib.mkIf (!isLighthouse) [ "100.100.0.1" ];

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

        relays = lib.mkIf (!isLighthouse) [ "100.100.0.1" ];
      };
    };
}

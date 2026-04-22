# nix/modules/nebula.nix
{ inputs, config, lib, pkgs, ... }:

let
  host = config.networking.hostName;

  isLighthouse = host == "lighthouse";

  sopsFile = /secrets/nebula.yaml;

  nebulaUser = "nebula-pertaka";
  nebulaGroup = "nebula-pertaka";

  # Helper for secrets
  secret = name: config.sops.secrets."nebula/${name}".path;

  lighthouseIP =
    builtins.readFile
      config.sops.secrets."nebula/lighthouse_ip".path;

in
{
  options.services.nebula.enable = lib.mkEnableOption "Nebula pertaka mesh";

  config = lib.mkIf config.services.nebula.enable {

    environment.systemPackages = [ pkgs.nebula ];

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

    # --- Nebula config ---
    services.nebula.networks.pertaka = {
      ca   = secret "ca";
      cert = secret "${host}/cert";
      key  = secret "${host}/key";

      staticHostMap = {
        "100.100.0.1" = [ lighthouseIP ];
      };

      lighthouses = lib.mkIf (!isLighthouse) [
        "100.100.0.1"
      ];

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

      relays = lib.mkIf (!isLighthouse) [
        "100.100.0.1"
      ];
    };
  };
}
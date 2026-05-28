{
  flake.factory.nebulaSecrets =
    { vm }:
    { config, lib, inputs, ... }:

    let
      sopsFile = "${inputs.secrets}/secrets/nebula.yaml";
    in
    {
      systemd.tmpfiles.rules = [
        "d /var/lib/microvms/${vm}/nebula 0750 root root -"
      ];

      sops.secrets."nebula.${vm}.ca" = {
        inherit sopsFile;
        key = "nebula/ca";
        path = "/var/lib/microvms/${vm}/nebula/ca.crt";
        mode = "0400";
      };

      sops.secrets."nebula.${vm}.crt" = {
        inherit sopsFile;
        key = "nebula/${vm}/crt";
        path = "/var/lib/microvms/${vm}/nebula/host.crt";
        mode = "0400";
      };

      sops.secrets."nebula.${vm}.key" = {
        inherit sopsFile;
        key = "nebula/${vm}/key";
        path = "/var/lib/microvms/${vm}/nebula/host.key";
        mode = "0400";
      };
    };
}
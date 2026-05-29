{
  inputs,
  ...
}:
{
  flake.factory.nebulaSecrets =
    { vm }:
    let
      sopsFile = "${inputs.secrets}/secrets/nebula.yaml";
    in
    { config, lib, ... }:
    {
      # Host-only module produced by the factory
      systemd.tmpfiles.rules = [
        "d /persist/microvms/state/${vm}/nebula 0750 root root -"
      ];

      sops.secrets."nebula.${vm}.ca" = {
        sopsFile = sopsFile;
        key = "nebula/ca";
        path = "/persist/microvms/state/${vm}/nebula/ca.crt";
        mode = "0400";
      };

      sops.secrets."nebula.${vm}.crt" = {
        sopsFile = sopsFile;
        key = "nebula/${vm}/crt";
        path = "/persist/microvms/state/${vm}/nebula/host.crt";
        mode = "0400";
      };

      sops.secrets."nebula.${vm}.key" = {
        sopsFile = sopsFile;
        key = "nebula/${vm}/key";
        path = "/persist/microvms/state/${vm}/nebula/host.key";
        mode = "0400";
      };
    };
}

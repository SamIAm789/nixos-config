{
  inputs,
  ...
}:
{
  flake.factory.nebulaSecrets =
    { vm }:
    let
      sopsFile = "${inputs.secrets}/secrets/nebula.yaml";
      nebulaUid = 998;
      nebulaGid = 998;
    in
    { config, lib, ... }:
    {
      # Host-only module produced by the factory
      systemd.tmpfiles.rules = [
        "d /var/lib/microvms/${vm}/nebula 0750 root root -"
      ];

      sops.secrets."nebula.${vm}.ca" = {
        sopsFile = sopsFile;
        key = "nebula/ca";
        path = "/var/lib/microvms/${vm}/nebula/ca.crt";
        mode = "0400";
        owner = nebulaUid;
        group = nebulaGid;
      };

      sops.secrets."nebula.${vm}.crt" = {
        sopsFile = sopsFile;
        key = "nebula/${vm}/crt";
        path = "/var/lib/microvms/${vm}/nebula/host.crt";
        mode = "0400";
        owner = nebulaUid;
        group = nebulaGid;
      };

      sops.secrets."nebula.${vm}.key" = {
        sopsFile = sopsFile;
        key = "nebula/${vm}/key";
        path = "/var/lib/microvms/${vm}/nebula/host.key";
        mode = "0400";
        owner = nebulaUid;
        group = nebulaGid;
      };
    };
}

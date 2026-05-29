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

      sops.secrets."nebula.${vm}.ca" = {
        sopsFile = sopsFile;
        key = "nebula/ca";
        path = "/run/secrets/nebula/${vm}/ca.crt";
        mode = "0400";
      };

      sops.secrets."nebula.${vm}.crt" = {
        sopsFile = sopsFile;
        key = "nebula/${vm}/crt";
        path = "/run/secrets/nebula/${vm}/nebula/host.crt";
        mode = "0400";
      };

      sops.secrets."nebula.${vm}.key" = {
        sopsFile = sopsFile;
        key = "nebula/${vm}/key";
        path = "/run/secrets/nebula/${vm}/host.key";
        mode = "0400";
      };
    };
}

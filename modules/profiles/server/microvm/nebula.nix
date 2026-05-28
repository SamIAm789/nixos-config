{
  inputs,
  ...
}:
{
  flake.modules.nixos.nebulaMicrovmSecrets =
    {
      config,
      lib,
      ...
    }:
    let
      sopsFile =
        "${inputs.secrets}/secrets/nebula.yaml";

      mkVm = name: _: {
        systemd.tmpfiles.rules = [
          "d /var/lib/microvms/${name}/nebula 0750 root root -"
        ];

        sops.secrets."nebula.${name}.ca" = {
          inherit sopsFile;
          key = "nebula/ca";
          path = "/var/lib/microvms/${name}/nebula/ca.crt";
          mode = "0400";
        };

        sops.secrets."nebula.${name}.crt" = {
          inherit sopsFile;
          key = "nebula/${name}/crt";
          path = "/var/lib/microvms/${name}/nebula/host.crt";
          mode = "0400";
        };

        sops.secrets."nebula.${name}.key" = {
          inherit sopsFile;
          key = "nebula/${name}/key";
          path = "/var/lib/microvms/${name}/nebula/host.key";
          mode = "0400";
        };
      };
    in
    {

      options.microvmNebula.vms = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of MicroVMs that should receive Nebula secrets.";
      };

      config = lib.mkMerge (map mkVm (config.microvmNebula.vms or []));
    };
}

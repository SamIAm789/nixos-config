{
  inputs,
  ...
}:
{
  flake.modules.nixos.nebula =
  {
    config,
    lib,
    ...
  }:
  {
    imports = [
      inputs.dotfiles.modules.nixos.nebula
    ];

    services.nebula.networks.pertaka = {
      ca   = lib.mkForce "/run/secrets/nebula/ca.crt";
      cert = lib.mkForce "/run/secrets/nebula/host.crt";
      key  = lib.mkForce "/run/secrets/nebula/host.key";
    };

    microvm.shares = [
      {
        proto = "virtiofs";
        tag = "nebula-secrets";
        source = "/var/lib/microvms/${config.networking.hostName}/nebula";
        mountPoint = "/run/secrets/nebula";
        readOnly = true;
      }
    ];
    systemd.tmpfiles.rules = [
        # directory owned by nebula-pertaka, only it can read it
        "d /run/secrets/nebula 0750 nebula-pertaka nebula-pertaka -"
    ];
  };
}

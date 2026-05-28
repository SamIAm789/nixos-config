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
        readonly = true;
      }
    ];
  };
}

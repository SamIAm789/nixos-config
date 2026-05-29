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
      ca   = lib.mkForce "/var/lib/nebula/ca.crt";
      cert = lib.mkForce "/var/lib/nebula/host.crt";
      key  = lib.mkForce "/var/lib/nebula/host.key";
    };

    microvm.shares = [
      {
        proto = "virtiofs";
            tag = "nebula-secrets";
            source = "/persist/microvms/state/${config.networking.hostName}/nebula";
            mountPoint = "/var/lib/nebula";
            readOnly = true;
      }
    ];

    systemd.tmpfiles.rules = [
      "d /var/lib/nebula 0750 nebula-pertaka nebula-pertaka -"
    ];
  };
}

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
      ca   = lib.mkForce "/etc/nebula/ca.crt";
      cert = lib.mkForce "/etc/nebula/host.crt";
      key  = lib.mkForce "/etc/nebula/host.key";
    };

    microvm.shares = [
      {
        proto = "virtiofs";
            tag = "nebula-secrets";
            source = "/persist/microvms/state/${config.networking.hostName}/nebula";
            mountPoint = "/etc/nebula";
            readOnly = true;
      }
    ];
    systemd.tmpfiles.rules = [
      # Fix directory permissions
      "d /etc/nebula 0750 nebula-pertaka nebula-pertaka -"
    ];
  };
}

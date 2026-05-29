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

    systemd.services.nebula-prepare-secrets = {
      description = "Prepare Nebula secrets";
      after = [ "local-fs.target" ];
      before = [ "nebula@pertaka.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          install -m 0400 -o nebula-pertaka -g nebula-pertaka \
            /var/lib/nebula/ca.crt   /etc/nebula/ca.crt
          install -m 0400 -o nebula-pertaka -g nebula-pertaka \
            /var/lib/nebula/host.crt /etc/nebula/host.crt
          install -m 0400 -o nebula-pertaka -g nebula-pertaka \
            /var/lib/nebula/host.key /etc/nebula/host.key
        '';
      };
    };
  };
}

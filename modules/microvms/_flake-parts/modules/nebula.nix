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
            source = "/persist/secrets/nebula/${config.networking.hostName}";
            mountPoint = "/var/lib/nebula";
            readOnly = true;
      }
    ];

    systemd.tmpfiles.rules = [
      "d /var/lib/nebula 0750 nebula-pertaka nebula-pertaka -"
    ];

    # Fix ownership and permissions *after* the mount is active
    systemd.services.nebula-ownership-fix = {
      description = "Fix ownership of mounted Nebula secrets";
      after = [ "microvm-mount-nebula-secrets.service" ];  # adjust if tag changes
      requires = [ "microvm-mount-nebula-secrets.service" ];
      before = [ "nebula-pertaka.service" ];
      wantedBy = [ "nebula-pertaka.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
      };

      script = ''
        # The files are owned by root on the host, so we chown them inside the guest namespace
        chown nebula-pertaka:nebula-pertaka /var/lib/nebula/*.crt /var/lib/nebula/*.key 2>/dev/null || true
        chmod 400 /var/lib/nebula/*.key
        chmod 444 /var/lib/nebula/*.crt
      '';
    };
  };
}

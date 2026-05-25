{
  flake.modules.nixos.preservation =
    {
      pkgs,
      ...
    }:
    {

# Enable systemd in initrd
      boot.initrd.systemd.enable = true;

      boot.supportedFilesystems = [ "zfs" ];
      boot.initrd.supportedFilesystems = [ "zfs" ];

      # systemd in initrd requires a service instead of a command
      boot.initrd.systemd.services.reset = {
        description = "reset root filesystem";
        wantedBy = [ "initrd.target" ];
        after = [ "zfs-import-system.service" ];
        before = [ "sysroot.mount" ];
        path = with pkgs; [ zfs ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = "zfs rollback -r rpool/local/root@blank";
      };
    };
}

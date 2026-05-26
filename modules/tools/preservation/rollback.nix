{
  flake.modules.nixos.preservation =
    {
      pkgs,
      ...
    }:
    {

# Enable systemd in initrd
      boot = {
        zfs.devNodes = "/dev/disk/by-id";
        initrd = {
          systemd.enable = true;
          supportedFilesystems = [ "zfs" ];
          kernelModules = [
            "zfs"
            "zcommon"
            "znvpair"
            "zavl"
            "zunicode"
          ];
        };
      };

      # systemd in initrd requires a service instead of a command
      boot.initrd.systemd.services.rollback = {
        description = "rollback root filesystem";
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

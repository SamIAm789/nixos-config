{
  flake.modules.nixos.zfs = {

    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.forceImportRoot = false;
    networking.hostId = "6c0ee112";
    services.zfs.autoScrub.enable = true;

}
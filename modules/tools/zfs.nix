{
  flake.modules.nixos.zfs = 

  let
    hash = builtins.hashString "sha256" config.networking.hostName;

    hostId = builtins.substring 0 8 hash;
  in
  {

    boot = {
      supportedFilesystems = [ "zfs" ];
      zfs.forceImportRoot = false;
    };
    networking.hostId = hostId;
    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
  };
}
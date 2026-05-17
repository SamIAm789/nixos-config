{
  flake.modules.nixos.ntfy = {
    services.zfs.zed.settings = {
      ZED_NTFY_TOPIC = "zfs";
      ZED_NTFY_URL = "http://10.25.0.24:8090";
      ZED_NOTIFY_VERBOSE = "0"; # only alert on failures
    };
  };
}

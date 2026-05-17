{
  flake.modules.nixos.ntfy = {
    services.ntfy-sh = {
      enable = true;
      settings = {
        listen-http = ":8090";
        default-host = "http://10.25.0.24:8090";
        cache-file = "/var/lib/ntfy-sh/cache.db";
        attachment-cache-dir = "/var/lib/ntfy-sh/attachments";
      };
      settings.base-url = "http://10.25.0.24";
    };

    networking.firewall.allowedTCPPorts = [ 8090 ];
  };
}

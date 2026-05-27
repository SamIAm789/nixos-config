{
  pkgs,
  ...
}:
let
  # Hash the hostname → take first 5 bytes
  hash = builtins.hashString "sha256" config.networking.hostName;

  # Extract bytes from the hash
  b1 = "02";  # locally-administered, unicast
  b2 = builtins.substring 0 2 hash;
  b3 = builtins.substring 2 2 hash;
  b4 = builtins.substring 4 2 hash;
  b5 = builtins.substring 6 2 hash;
  b6 = builtins.substring 8 2 hash;

  mac = "${b1}:${b2}:${b3}:${b4}:${b5}:${b6}";
in
{

  networking.hostName = "immich-vm";
  system.stateVersion = "25.11";

  # ── MicroVM Configuration ─────────────────────────────────────────────
  microvm = {
    hypervisor = "cloud-hypervisor";
    vcpu = 2;
    mem = 2048;
    hotplugMem = 4096;

    interfaces = [{
      type = "tap";
      id = "vm-immich";
      mac = mac;
    }];

    vsock.cid = 100;

    # Persistent root disk (Very Important!)
    volumes = [{
      image = "/persist/microvms/immich/root.img";
      mountPoint = "/";
      size = 16384;           # 16GB
      fsType = "ext4";
      autoCreate = true;
    }];

    shares = [
      {
        proto = "virtiofs";
        tag = "photos";
        source = "/stuff/photos";
        mountPoint = "/stuff/photos";
        socket = "photos.socket";
      }
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];
  };

  # ── Networking ────────────────────────────────────────────────────────
  systemd.network.enable = true;
  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig.DHCP = "yes";
  };

  # ── User ──────────────────────────────────────────────────────────────
  users.users.sam = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";   # Change this soon!
  };

  # ── SSH ───────────────────────────────────────────────────────────────
  services.openssh.enable = true;

  # ── Immich ────────────────────────────────────────────────────────────
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2284;
    mediaLocation = "/stuff/photos";
    openFirewall = true;
  };
}

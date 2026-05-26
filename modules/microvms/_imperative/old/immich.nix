{ config, lib, pkgs, ... }:

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
      mac = "02:00:00:00:00:01";
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

  # ── Quality of Life ───────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    htop iotop
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

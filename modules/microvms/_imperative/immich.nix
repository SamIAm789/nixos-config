{
  pkgs,
  microvm,
  ...
}:
{
  imports = [
    microvm.nixosModules.microvm
  ];

  # ── Basic System ─────────────────────────────────────────────────────
  networking.hostName = "immich-vm";
  system.stateVersion = "25.11";

  # ── MicroVM Hardware ─────────────────────────────────────────────────
  microvm = {
    hypervisor = "cloud-hypervisor";
    vcpu = 2;
    mem = 2 * 1024;           # 2GB base
    hotplugMem = 4 * 1024;

    interfaces = [{
      type = "tap";
      id = "vm-immich";
      mac = "02:00:00:00:00:01";
    }];

    volumes = [{
      image = "/persist/microvms/immich/root.img";
      mountPoint = "/";
      size = 16384;       # 16 GB
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

  # ── Networking ───────────────────────────────────────────────────────
  systemd.network.enable = true;
  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig.DHCP = "yes";
  };

  # ── User ─────────────────────────────────────────────────────────────
  users.users.sam = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";   # Change this after first login!
  };

  # ── SSH ──────────────────────────────────────────────────────────────
  services.openssh.enable = true;

  # ── Immich ───────────────────────────────────────────────────────────
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2284;
    mediaLocation = "/stuff/photos";
    openFirewall = true;
  };

  # Enable this if you want machine learning (needs more RAM/CPU)
  # services.immich.machine-learning.enable = true;

  # ── Basic tools ──────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    htop iotop
  ];

  # Allow nix commands inside the VM
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

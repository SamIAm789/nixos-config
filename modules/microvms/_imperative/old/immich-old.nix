{ config, lib, pkgs, ... }: {

  networking.hostName = "immich-vm";

  microvm = {
    interfaces = [ {
        type = "tap";
        id = "vm-immich";
        mac = "02:00:00:00:00:01";
    } ];
    shares = [ {
        proto = "virtiofs";
        tag = "photos";
        source = "/stuff/photos";
        mountPoint = "/stuff/photos";
        socket = "photos.socket";
    } ];

    vsock.cid = 100;
    # set dataset options to -o xattr=sa -o acltype=posixacl
    mem = 2 * 1024;
    hotplugMem = 4 * 1024; #max amount of extra mem that can be added with virtio-men
    hypervisor = "cloud-hypervisor";
    vcpu = 2;
  };

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2284;
    mediaLocation = "/stuff/photos";
    openFirewall = true;
  };

  users.users.sam = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };


  services.openssh.enable = true;

  systemd.network.enable = true;

  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig = {
      DHCP = "yes";
    };
  };

  system.stateVersion = "25.11";
}

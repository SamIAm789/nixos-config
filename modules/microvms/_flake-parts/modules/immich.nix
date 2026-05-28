{
  inputs,
  ...
}:
{
  flake.modules.nixos.immich = {

    imports = [
      inputs.dotfiles.modules.nixos.nebula
    ];

    microvm = {
      hypervisor = "cloud-hypervisor";
      vcpu = 2;
      mem = 2048;
      hotplugMem = 4096;

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
          source = "/stuff/immich-test";
          mountPoint = "/stuff/photos";
          socket = "photos.socket";
        }
      ];
    };

    services.immich = {
      enable = true;
      host = "0.0.0.0";
      port = 2284;
      mediaLocation = "/stuff/photos";
      openFirewall = true;
    };
  };
}

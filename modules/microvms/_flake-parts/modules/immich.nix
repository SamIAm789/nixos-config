{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkMicroVM "x86_64-linux" "immich-test";

  flake.modules.nixos.immich-test = {

    imports = [
      inputs.dotfiles.modules.nixos.nebula
      inputs.self.modules.nixos.nebula
    ];

    microvm = {
      hypervisor = "cloud-hypervisor";
      vcpu = 2;
      mem = 2048;
      hotplugMem = 4096;

      vsock.cid = 100;

      # Persistent root disk (Very Important!)
      volumes = [{
        image = "/persist/microvms/immich-test/root.img";
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

    system.stateVersion = "26.05";
  };
}

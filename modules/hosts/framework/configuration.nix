{ self, inputs, ... }: {

  flake.nixosModules.frameworkConfiguration = { pkgs, lib, ... }: {

    imports = [
      self.nixosModules.frameworkHardware
      self.nixosModules.samHomeManager
    ];

    myOptions = {
      common.enable = true;
      flatpak.enable = true;
      hyprland.enable = true;
      nebula.enable = true;
      podman.enable = true;
    };

    networking.hostName = "framework";

    hardware.sensor.iio.enable = true;
    services.fprintd.enable = true;

    environment.systemPackages = with pkgs; [
      scrcpy # control android devices over usb
    ];

    system.stateVersion = "25.05";
  };
}

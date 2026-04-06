{ self, inputs, ... }: {

  flake.nixosModules.podman = { lib, config, pkgs, qualet-nix, ... }: {

    options = {
      myOptions.podman.enable =
        lib.mkEnableOption "enables podman";
    };

    config = lib.mkIf config.podman.enable {

      virtualisation.podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
        defaultNetwork.settings = {
          dns_enabled = true;
        };
      };

      virtualisation.quadlet.enable = true;

      # Enable container name DNS for non-default Podman networks.
      # https://github.com/NixOS/nixpkgs/issues/226365
      networking.firewall.interfaces."podman*".allowedUDPPorts = [ 53 ];

      virtualisation.oci-containers.backend = "podman";

      users.users.sam = {
        extraGroups = [ "podman" ];
        linger = true;
        autoSubUidGidRange = true;
      };

      environment.systemPackages = with pkgs; [
        podman-tui
        podman-compose
      ];
    };
  };
}

{
  flake.modules.nixos.impermanence = {

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        # System identity
        "/var/lib/systemd"
        "/var/lib/nixos"

        # Logs
        "/var/log"

        # sops-nix host AGE keys
        "/var/lib/sops-nix"

        "/persist/containers"

        # Rootless Podman
        "/home/sam/.local/share/containers"
        "/home/sam/.config/containers"

        # Rootless Quadlet
        "/home/sam/.config/systemd/user"

        # SSH identity
        "/home/sam/.ssh"

        # Optional: persist root home
        "/root"

        # Host SSH keys
        {
          directory = "/etc/ssh";
          user = "root";
          group = "root";
          mode = "0700";
        }
      ];

      files = [
        "/etc/machine-id"
        "/home/sam/.config/sops/age/keys.txt"
      ];
    };
  };
}

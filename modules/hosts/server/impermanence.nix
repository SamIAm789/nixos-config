{
  flake.modules.nixos.impermanence-server = {

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
      ];

      users.sam = {
        directories = [
          ".ssh"
          ".config/systemd/user"
          ".config/containers"
          ".local/share/containers"
        ];
        files = [
          "/home/sam/.config/sops/age/keys.txt"
        ];
      };
    };
  };
}

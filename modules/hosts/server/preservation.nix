{
  flake.modules.nixos.server = {

    preservation = {
      enable = true;

      preserveAt."/persist" = {
        directories = [
          # System identity
          "/var/lib/systemd"
          "/var/lib/systemd/timers"
          "/var/log"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }

          # sops-nix host AGE keys
          "/var/lib/sops-nix"

          "/persist/containers"

          # Host SSH keys
          {
            directory = "/etc/ssh";
            user = "root";
            group = "root";
            mode = "0700";
          }
        ];

        files = [
          { file = "/etc/machine-id"; inInitrd = true; }
          #{ file = "/etc/ssh/ssh_host_ed25519_key"; how = "symlink"; configureParent = true; }
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
  };
}

environment.persistence."/persist" = {
  hideMounts = true;

  directories = [
    # System identity
    "/var/lib/systemd"
    "/var/lib/nixos"

    # Logs
    "/var/log"

    # Rootless Podman (mapped to tank/local/home/sam/podman)
    "/home/sam/.local/share/containers"
    "/home/sam/.config/containers"

    # Rootless Quadlet (mapped to tank/local/home/sam/quadlet)
    "/home/sam/.config/systemd/user"

    # SSH identity (mapped to tank/local/home/sam/ssh)
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
  ];
};
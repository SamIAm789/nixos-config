{
  flake.modules.nixos.server =
  {
    pkgs,
    ...
  }:
  {
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";

    systemd.tmpfiles.rules = [
      "d /var/lib/sops-nix 0700 root root -"
      "z /var/lib/sops-nix/key.txt 0400 root root -"
      "z /etc/ssh/ssh_host_ed25519_key 0600 root root -"
      "z /etc/ssh/ssh_host_ed25519_key.pub 0644 root root -"
    ];

    programs.ssh.extraConfig = ''
      Host github.com
        IdentityFile /root/.ssh/id_ed25519
        IdentitiesOnly yes
    '';

    systemd.user.services.clone-dotfiles = {
      description = "Clone dotfiles repository";

      wantedBy = [ "default.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      path = [ pkgs.git ];

      script = ''
        TARGET="$HOME/.dotfiles"

        if [ ! -d "$TARGET" ]; then
          echo "Cloning dotfiles into $TARGET"
          git clone https://github.com/SamIAm789/dotfiles.git "$TARGET"
        else
          echo "$TARGET already exists"
        fi
      '';
    };
  };
}

{
  flake.modules.nixos.server =
  {
    lib,
    ...
  }:
  {
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    environment.etc."var/lib/sops-nix/key.txt" = {
      source = "/extra-files/key.txt";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/sops-nix 0700 root root -"
      "f /var/lib/sops-nix/key.txt 0400 root root -"
    ];

    programs.ssh.extraConfig = ''
      Host github.com
        IdentityFile /root/.ssh/id_ed25519
        IdentitiesOnly yes
    '';
  };
}

{
  flake.modules.nixos.server = {
    sops.age.keyFile = "/var/lib/sops-nix/keys.txt";
    environment.etc."var/lib/sops-nix/keys.txt" = {
      source = "/extra-files/keys.txt";
      mode = "0600";
      user = "root";
      group = "root";
    };
  };
}

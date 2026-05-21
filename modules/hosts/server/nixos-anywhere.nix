{
  flake.modules.nixos.server =
  {
    lib,
    ...
  }:
  {
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    environment.etc."var/lib/sops-nix/key.txt" = {
      source = "/extra-files/keys.txt";
    };
  };
}

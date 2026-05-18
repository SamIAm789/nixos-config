{
  inputs,
  ...
}:
{
  flake.modules.nixos.server = {

    imports = with inputs.self.modules.nixos; [
      disko
      ./disk-config.nix
      sam
      server-filesystems
      server-hardware
    ];

    networking.hostId = "6c0ee112";
  };
}

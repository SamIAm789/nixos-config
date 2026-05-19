{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "server";

  flake.modules.nixos.server = {

    imports = with inputs.self.modules.nixos; [
      disko
      ./disk-config.nix
      sam
      server-profile
      server-filesystems
      server-hardware
    ];

    networking.hostId = "6c0ee112";

    system.stateVersion = "25.11";
  };
}

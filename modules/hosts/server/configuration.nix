{
  inputs,
  ...
}:
{
  flake.modules.nixos.server = {

    imports = with inputs.self.modules.nixos; [
      disko
      inputs.disko.nixosModules.disko
      ./disk-config.nix
    ];

    networking.hostId = "6c0ee112";
  };
}

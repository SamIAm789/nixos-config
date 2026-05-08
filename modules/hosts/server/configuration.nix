{
  flake.modules.nixos.server = { lib, config, ... }: {

    imports with.self.nixos = [

    ];

    networking.hostId = "6c0ee112";


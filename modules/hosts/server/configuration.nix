{
  inputs,
  ...
}:
{
  flake.modules.nixos.server = {

    imports = with inputs.self.nixos; [

    ];

    networking.hostId = "6c0ee112";
  };
}

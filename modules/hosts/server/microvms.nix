{
  self,
  ...
}:
{
  flake.modules.nixos.server = {

    imports = [
      (self.factory.nebulaSecrets { vm = "immich"; })
    ];

    microvm.autostart = [
      "immich"
    ];
  };
}

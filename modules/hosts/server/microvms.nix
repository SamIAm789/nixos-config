{
  self,
  ...
}:
{
  flake.modules.nixos.server = {

    imports = [
      (self.factory.nebulaSecrets { vm = "immich-test"; })
    ];

    microvm.autostart = [
      "immich"
    ];
  };
}

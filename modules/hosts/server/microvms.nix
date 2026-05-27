{
  flake.modules.nixos.server = {
    microvm.autostart = [
      "immich"
    ];
  };
}

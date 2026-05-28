{
  flake.modules.nixos.server = {
    microvm.autostart = [
      "immich"
    ];
    microvmNebula.vms = [
      "immich-test"
    ];
  };
}

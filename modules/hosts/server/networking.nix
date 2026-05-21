{
  flake.modules.nixos.server = {
    networking = {
      hostId = "6c0ee112";
      interfaces.eno1.macAddress = "9c:7b:ef:25:a8:98";
    };
  };
}

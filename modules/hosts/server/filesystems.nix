{
  fileSystems."/" = {
    device = "server/local/root";
    fsType = "zfs";
  };
  
  fileSystems."/nix" = {
    device = "server/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "server/local/home";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "server/local/persist";
    fsType = "zfs";
    neededForBoot = true;
  };
}
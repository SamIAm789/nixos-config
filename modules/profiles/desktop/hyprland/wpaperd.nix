{
  flake.modules.homeManager.wpaperd = {

    services.wpaperd = {
      enable = true;
      settings = {
        default = {
          path = "/home/sam/.wallpapers";
          sorting = "random";
          duration = "30m";
          group = 1;
        };
      };
    };
  };
}

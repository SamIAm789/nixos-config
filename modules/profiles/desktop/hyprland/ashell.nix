{
  flake.modules.homeManager.ashell = {

    programs.ashell = {
    enable = true;
    systemd = {
      enable = true;
      #target = "hyprland-session.target";
    };
    settings = {
      outputs = "All";
      position = "Top";
      modules = {
        left = [ "Workspaces" ];
        center = [ "Clock" ];
        right = [ "Settings" ];
      };
      clock = {
        format = "%d %b %R";
      };
      appearance = {
        opacity = 0.5;
      };
    };
  };
}
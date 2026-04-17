{
  flake.module.homeManager.hypridle = {


    services.hypridle = {

    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyperlock";
      };

     listener = [
       {
          timeout = 300; # 5 min
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
          
       }
       {
          timeout = 450; # 7.5 min
          on-timeout = "loginctl lock-session";
       }
       {
          timeout = 500;
          on-timeout = "hyprctl dispatch dpms off"; # screen off
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
       }
       {
          timeout = 1800; # 30 min
          on-timeout = "systemctl suspend";
       }
     ];
   };
  };
}
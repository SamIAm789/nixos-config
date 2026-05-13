{
  flake.modules.nixos.power-management = {
    services = {
      logind.settings.Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "lock";
        HandleLidSwitchDocked = "ignore";
        # one of "ignore", "poweroff", "reboot", "halt", "kexec", "suspend", "hibernate", "hybrid-sleep", "suspend-then-hibernate", "lock"
      };
      thermald.enable = true; # only for intel CPUs
      tlp = {
        enable = true;
        pd.enable = true;
      };
      upower.enable = true; # needed for battery status icons
    };
  };
}

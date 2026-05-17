{
  flake.modules.nixos.ntfy = {
    systemd.services = lib.mkOption {
      type = with lib.types; attrsOf (
        submodule {
          config.onFailure = [ "ntfy-failure@%i.service" ];
        }
      );
    };
    
    systemd.services."ntfy-failure@" = {
      enable = true;
      description = "Failure notification for %i";
      scriptArgs = "%i %n %H"; # content after '@' will be sent as '$1' in the script
      script = ''${pkgs.curl}/bin/curl \
                 --fail \
                 --show-error --silent \
                 --max-time 10 \
                 --retry 3 \
                 --data "[$1@$3] Service $1 failed\n$(journalctl --unit $1 --lines 5 --reverse --no-pager --boot | head -c 4095)" http://10.25.0.24:8090/server
                 '';     
      };
    };
  }

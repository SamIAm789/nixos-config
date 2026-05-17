{
  flake.modules.nixos.ntfy =
  {
    config,
    lib,
    pkgs,
    ...
  }:
  let 
    ntfy-ssh = with pkgs; writeShellApplication { #https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-writeShellApplication
      name = "ntfy-ssh";
      runtimeInputs = [ curl ];
      text = ''
        if [ "''${PAM_TYPE}" = "open_session" ]; then
        curl \
          --fail \
          --show-error --silent \
          --max-time 10 \
          --retry 3 \
          -H prio:high \
          -H tags:warning \
          --data "SSH login: ''${PAM_USER} from ''${PAM_RHOST}" \
          http://10.25.0.24:8090/server
        fi
      '';
    };
  in
  {
  
    security.pam.services.sshd.rules.session.ntfy = {
      enable = true;
      control = "optional";
      order = config.security.pam.services.sshd.rules.session.systemd.order + 10;
      modulePath = "pam_exec.so"; #"${config.security.pam.package}/lib/security/pam_exec.so";
      args = [ "${ntfy-ssh}/bin/ntfy-ssh" ];
    };
  };
}

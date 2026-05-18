{
  flake.modules.nixos.openclaw = {

    users.users.openclaw = {
      isSystemUser = true;
      group = "openclaw";
    };

    users.groups.openclaw = {};

    systemd.services.openclaw = {
      description = "OpenClaw AI Agent";

      after = [ "network.target" "ollama.service" ];

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "openclaw";
        Group = "openclaw";

        ExecStart = "${pkgs.openclaw}/bin/openclaw daemon";

        Restart = "always";

        RestartSec = 5;

        NoNewPrivileges = true;
        PrivateTmp = true;

        ProtectSystem = "strict";
        ProtectHome = true;

        WorkingDirectory = "/var/lib/openclaw";
        StateDirectory = "openclaw";
      };

      environment = {
        OLLAMA_HOST = "http://127.0.0.1:11434";
      };
    };
  };
}

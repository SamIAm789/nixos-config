{
  inputs,
  ...
}:
{
  flake.factory.nebulaSecrets =
    { vm, storageDir ? "/persist/secrets/nebula/${vm}" }:
    { config, lib, ... }:
    let
      sopsFile = "${inputs.secrets}/secrets/nebula.yaml";
    in
    {
      # SOPS secrets
      sops.secrets."nebula.${vm}.ca" = {
        sopsFile = sopsFile;
        key = "nebula/ca";
        path = "/run/secrets/nebula/${vm}/ca.crt";
        mode = "0400";
      };

      sops.secrets."nebula.${vm}.crt" = {
        sopsFile = sopsFile;
        key = "nebula/${vm}/crt";
        path = "/run/secrets/nebula/${vm}/host.crt";
        mode = "0400";
      };

      sops.secrets."nebula.${vm}.key" = {
        sopsFile = sopsFile;
        key = "nebula/${vm}/key";
        path = "/run/secrets/nebula/${vm}/host.key";
        mode = "0400";
      };

      systemd.tmpfiles.rules = [
        "d ${storageDir} 0700 root root -"
      ];

      # More reliable copy service
      systemd.services."nebula-secrets-copy-${vm}" = {
        description = "Copy Nebula secrets for ${vm} to persistent storage";
        after = [ "sops-nix.service" ];
        requires = [ "sops-nix.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "root";
        };

        script = ''
          echo "=== Starting Nebula secrets copy for ${vm} ==="
          mkdir -p ${storageDir}

          if [ ! -f /run/secrets/nebula/${vm}/ca.crt ]; then
            echo "ERROR: Source secrets not found in /run/secrets!"
            exit 1
          fi

          cp -f /run/secrets/nebula/${vm}/ca.crt     ${storageDir}/ca.crt
          cp -f /run/secrets/nebula/${vm}/host.crt   ${storageDir}/host.crt
          cp -f /run/secrets/nebula/${vm}/host.key   ${storageDir}/host.key

          chmod 444 ${storageDir}/*.crt
          chmod 400 ${storageDir}/*.key
          chown root:root ${storageDir}/*

          echo "Secrets successfully copied to ${storageDir}"
          ls -la ${storageDir}
        '';
      };
    };
}
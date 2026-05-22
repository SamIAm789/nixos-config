{
  inputs,
  ...
}:
{
  flake.modules.nixos.server = {
    sops.secrets."server-shh" = {
        sopsFile = "${inputs.secrets}/secrets/server-ssh";
        owner = "root";
        group = "root";
        mode = "0400";
        path = "/etc/ssh/keys/secrets-deploy";
      };

      programs.ssh.knownHosts.github = {
        hostNames = [ "github.com" ];
        publicKey = "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN4mVVQnfUoPcTyjq8Kla/iX4Gjc/CWXPzd+5SMPLLZ3 server-github-key";
      };

      # Git fetches for sops-nix
      environment.variables.GIT_SSH_COMMAND =
        "ssh -i /etc/ssh/keys/secrets-deploy -o IdentitiesOnly=yes";
  };
}

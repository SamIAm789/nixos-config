{ inputs, ... }:

{
  flake.nixosModules.secrets = {
    imports = [
      inputs.secrets.nixosModules.secrets
    ];
  };
}

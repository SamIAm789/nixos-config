{
  inputs,
  lib,
  ...
}:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {

    mkMicroVM = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.microvm.nixosModules.microvm
          inputs.sops-nix.nixosModules.sops

          inputs.self.modules.nixos.microvm-base

          inputs.self.modules.microvm.${name}

          {
            nixpkgs.hostPlatform = lib.mkDefault system;
            networking.hostName = lib.mkDefault name;
          }
        ];
      };
    };

  };
}
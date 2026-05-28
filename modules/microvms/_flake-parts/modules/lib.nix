{
  inputs,
  self,
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
        inherit system;

        modules = [
          inputs.microvm.nixosModules.microvm
          self.modules.nixos.base
          self.modules.nixos.${name}

          {
            nixpkgs.hostPlatform = lib.mkDefault system;
            networking.hostName = lib.mkDefault name;
          }
        ];
      };
    };
  };
}
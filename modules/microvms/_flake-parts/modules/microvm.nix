{
  inputs,
  self,
  ...
}:
{
  systems = [ "x86_64-linux" ];

  flake.mkMicroVM =
    name:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        inputs.microvm.nixosModules.microvm
        inputs.sops-nix.nixosModules.sops
        inputs.dotfiles.modules.nixos.nebula

        self.modules.nixos.microvm-base

        {
          networking.hostName = name;
        }

        self.modules.microvm.${name}
      ];
    };

  flake.nixosConfigurations =
    builtins.mapAttrs
      (name: _: self.mkMicroVM name)
      self.modules.microvm;

  flake.packages.x86_64-linux =
    builtins.mapAttrs
      (name: _:
        self.nixosConfigurations.${name}
          .config.microvm.declaredRunner
      )
      self.modules.microvm;
}

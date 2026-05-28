{
  self,
  lib,
  ...
}:
{
  systems = [ "x86_64-linux" ];

  flake.nixosConfigurations =
    builtins.mapAttrs
      (
        name: _:
        self.lib.mkMicroVM {
          inherit name;
        }
      )
      self.modules.microvm;

  flake.packages.x86_64-linux =
    builtins.mapAttrs
      (
        name: _:
        self.nixosConfigurations.${name}
          .config.microvm.declaredRunner
      )
      self.modules.microvm;
}
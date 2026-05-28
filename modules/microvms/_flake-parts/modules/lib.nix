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

    mkMicroVM =
     {
       system ? "x86_64-linux",
       name,
       extraModules ? [ ],
     }:
     inputs.nixpkgs.lib.nixosSystem {
       inherit system;

       modules = [
         inputs.microvm.nixosModules.microvm
         inputs.sops-nix.nixosModules.sops
         self.modules.nixos.microvm-base
         {
           networking.hostName = name;
           nixpkgs.hostPlatform = system;
         }
         self.modules.microvm.${name}
       ]
       ++ extraModules;
     };
   };
}
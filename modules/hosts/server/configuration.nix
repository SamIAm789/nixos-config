{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "server";

  flake.modules.nixos.server = {

    imports = [
      inputs.disko.nixosModules.disko
      inputs.self.modules.nixos.disko
      ./disk-config.nix
      inputs.self.modules.nixos.sam
      inputs.self.modules.nixos.server-profile
      inputs.self.modules.nixos.server-filesystems
      inputs.self.modules.nixos.server-hardware
    ];

    system.stateVersion = "25.11";

  };
}

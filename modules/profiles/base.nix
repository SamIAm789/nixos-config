{ inputs, ... }:

{
  flake.nixosModules.profile-base = {
    imports = [
      inputs.self.nixosModules.common-system
      inputs.self.nixosModules.common-networking
      inputs.self.nixosModules.common-users
      inputs.self.nixosModules.common-hardware
      inputs.self.nixosModules.common-security
      inputs.self.nixosModules.common-locale

      inputs.self.nixosModules.home-manager
      inputs.self.nixosModules.flatpak
      inputs.self.nixosModules.quadlet
    ];
  };
}
{
  description = "Sam's MicroVMs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, microvm, ... }:
  let
    system = "x86_64-linux";

    # Helper function to create a MicroVM
    mkMicroVM = name: entrypoint: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        entrypoint
        microvm.nixosModules.microvm
        {
          # Global microvm defaults (optional)
          networking.hostName = name;
          system.stateVersion = "25.11";
        }
      ];
    };
  in {
    # For imperative `microvm` CLI usage
    microvm.config = {
      immich = mkMicroVM "immich" ./immich.nix;
      # Add more VMs here easily:
      # nextcloud = mkMicroVM "nextcloud" ./nextcloud.nix;
      # vaultwarden = mkMicroVM "vaultwarden" ./vaultwarden.nix;
    };

    # Also expose as regular nixosConfigurations (useful for debugging)
    nixosConfigurations = {
      immich = mkMicroVM "immich" ./immich.nix;
      # nextcloud = mkMicroVM "nextcloud" ./nextcloud.nix;
    };
  };
}

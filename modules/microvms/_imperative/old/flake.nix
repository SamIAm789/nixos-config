{

  description = "Sam's Nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, microvm, ... } @inputs:

  {

    nixosConfigurations =

    let

      system = "x86_64-linux";

      mkMicroVM = entrypoint: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
           entrypoint
          microvm.nixosModules.microvm
        ];
      };

    in

    {
      nixosConfigurations.immich = mkMicroVM ./immich.nix;

        # Best for the microvm CLI
      microvm.config.immich = mkMicroVM ./immich.nix;
    };
  };
}

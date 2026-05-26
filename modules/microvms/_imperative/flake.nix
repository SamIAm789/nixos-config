{
  description = "Sam's MicroVMs (imperative)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, microvm, ... } @ inputs:
  let
    system = "x86_64-linux";

    # mkVM: build a guest system + attach host-side options
    mkVM = name: guestModule: hostOpts: {
      ${name} = {
        # Guest OS (inside the VM)
        config = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            guestModule
            microvm.nixosModules.microvm
          ];
        };

        # Host-side MicroVM options
        inherit (hostOpts)
          stateDir
          waitForSocket
          autostart
          createSystemdUnit;
      };
    };
  in {
    #
    # Imperative MicroVMs
    #
    microvm.config = mkVM "immich" ./immich.nix {
      stateDir = "/persist/microvms/state/immich";

      # Host-side orchestration options
      waitForSocket = true;        # ← fixes your virtiofs race
      autostart = false;           # you run imperatively
      createSystemdUnit = false;   # no systemd wrapper
    };

    #
    # Optional: expose guest configs as nixosConfigurations
    #
    nixosConfigurations = {
      immich = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./immich.nix
          microvm.nixosModules.microvm
        ];
      };
    };
  };
}

{ self, inputs, ... }: {

  flake.nixosConfigurations.HOSTNAME = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.HOSTNAMEModule
      self.nixosModules.myHomeManager
    ];
  };

  flake.nixosModules.HOSTNAMEModule = { pkgs, ... }: {
    environment.systemPackages with pkgs = [

    ];

    users.users.USERNAME = {
      isNormalUser = true;
      shell = pkgs.fish;
    };
    home-manager.users.USERNAME = self.homeModules.USERNAMEModule;
  };

}

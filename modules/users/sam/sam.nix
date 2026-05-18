{
  inputs,
  self,
  ...
}:

let
  username = "sam";
in
{
  # flake.homeConfigurations = inputs.self.lib.mkHomeManager "x86_64-linux" "sam";

  flake.modules.nixos."${username}" =
    {
      config,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
      ];

      home-manager.users."${username}" = {
        imports = [
          inputs.self.modules.homeManager."${username}"
        ];
      };

      users.users."${username}" = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.sam.path;
        extraGroups = [
          "wheel"
        ];
      };

      sops.secrets.sam.neededForUsers = true;

    };

  flake.modules.homeManager."${username}" =
    {
      pkgs,
      osConfig,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [

      ];
      home.username = "${username}";
      home.packages = with pkgs; [
        spotify
      ];
      home.stateVersion = osConfig.system.stateVersion;
    };
}

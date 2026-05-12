{
  inputs,
  self,
  ...
}:

let
  username = "sam";
in
{
  flake.modules.nixos.${username} =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      home-manager.users."${username}" = {
        imports = [
          inputs.self.modules.homeManager."${username}"
        ];
      };

      users.users."${username}" = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.sam.path;
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
        ];
      };

      sops.secrets.sam.neededForUsers = true;

    };

  flake.modules.homeManager."${username}" =
    {
      pkgs,
      config,
      osConfig,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [

      ];
      home.username = "${username}";
      home.packages = with pkgs; [

      ];
      home.stateVersion = osConfig.system.stateVersion;
    };
}

{
  inputs,
  ...
}:

let
  username = "sam";
in
{
  flake.modules.nixos.${username} =
    {
      config,
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

      ];
      home.stateVersion = osConfig.system.stateVersion;
    };
}

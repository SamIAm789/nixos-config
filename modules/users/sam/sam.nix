{
  inputs,
  self,
  ...
}:

let
  username = "sam";
in
{
  flake.homeConfigurations = inputs.self.lib.mkHomeManager "x86_64-linux" "sam";

  flake.modules.nixos."${username}" =
    {
      config,
      ...
    }:
    let
      isVM = config.virtualisation ? qemu;
    in
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
        hashedPasswordFile =
             if isVM
             then null
             else config.sops.secrets.sam.path;

           initialHashedPassword =
             if isVM
             then "$y$j9T$isUS3neJEEFmJTYteyeHx1$RG2NFoIf.eBb0rELDl1aTCP0c4aC/33GpIKzFkCIKm2"  # hash of "password"
             else null;
        extraGroups = [
          "wheel"
        ];
      };

      sops.secrets.sam.neededForUsers = true;

    };

  flake.modules.homeManager."${username}" =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [

      ];
      home.username = "${username}";
      home.packages = with pkgs; [
        spotify
      ];
      home.stateVersion = "25.05";
    };
}

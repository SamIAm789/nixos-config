{ self, inputs, ... }: {

  flake.nixosModules.flatpak = { pkgs, lib, ... }: {

    options = {
      myOptions.flatpak.enable = lib.mkEnableOption "enable declaritive flatpak support during nix-flatpak and installs my flatpaks";
    };

    config = lib.mkIf config.myOptions.flatpak.enable {

    services.flatpak.enable = true;

    home-manager.users.sam = {

      imports = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];

      services.flatpak.packages = [
        "com.belmoussaoui.Authenticator"
        "com.github.tchx84.Flatseal"
        ];
      };
    };
  };
}

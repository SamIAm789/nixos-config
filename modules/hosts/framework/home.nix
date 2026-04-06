{ self, inputs, ... }: {

  flake.homeConfigurations.sam = inputs.home-manager.lib.homeConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux;" };
    modules = [
      self.homeModules.samModule
      {
        home.username = "sam";
        home.homeDirectory = "/home/sam";
      }
    ];
  };

  flake.homeModules.samModule = { pkgs, config, inputs, nix-flatpak, ... }: {
    home.packages = with pkgs; [

    ];
    myOptions = {
      firefox.enable = true;
      ssh-agent = true;
      starship.enable = true;
      wluma.enable = true;
      zed-editor.enable = true;
    };
    home.stateVersion = "25.05";
  };
}

{ self, inputs, ... }: {

  flake.nixosModules.common.enable = { pkgs, lib, config, ... }: {

    options = {
      myOptions.common.enable =
        lib.mkEnableOption "enables my common settings";
    };

    config = lib.mkIf config.myOptions.common {

      time.timeZone = "Australia/Brisbane";

      i18n.defaultLocale = "en_AU.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_AU.UTF-8";
        LC_IDENTIFICATION = "en_AU.UTF-8";
        LC_MEASUREMENT = "en_AU.UTF-8";
        LC_MONETARY = "en_AU.UTF-8";
        LC_NAME = "en_AU.UTF-8";
        LC_NUMERIC = "en_AU.UTF-8";
        LC_PAPER = "en_AU.UTF-8";
        LC_TELEPHONE = "en_AU.UTF-8";
        LC_TIME = "en_AU.UTF-8";
      };

      environment.systemPackages = with pkgs; [
        fzf
        git
      ];

      fish.enable = true;
      programs.zoxide = {
         enable = true;
         enableFishIntegration = true;
       };

      nixpkgs.config.allowUnfree = true;

      nix.settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
      };

      programs.nh = {
        enable = true;
        flake = "/home/sam/.dotfiles";
        clean = {
          enable = true;
          extraArgs = "--keep-since 14d";
        };
      };

      boot.loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}

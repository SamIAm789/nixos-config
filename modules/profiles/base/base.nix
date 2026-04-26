{ inputs, ... }: {

  flake.modules.nixos.base = {
    imports = with inputs.self.modules.base; [
      boot
      firmware
      fish
      nebula
      nix
      ssh-keys
      timezone
    ];

    environment.systemPackages = with pkgs; [
      fzf
      git
    ];
  };
}

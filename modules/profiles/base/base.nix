{ inputs, ... }: {

  flake.modules.nixos.base = {
    imports = with inputs.self.modules.base; [
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

{ inputs, ... }: {

  flake.modules.nixos.base = {
    imports = with inputs.self.modules.base; [
      firmware
      fish
      nebula
      nix
      timezone
    ];
  };
}

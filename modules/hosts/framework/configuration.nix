{ inputs, ... }: {

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "framework";

  flake.modules.nixos.framwork = {
    imports = with inputs.self.modules.nixos; [
      framework-hardware
    ];
  };
}

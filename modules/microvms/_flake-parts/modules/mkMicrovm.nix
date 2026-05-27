{
  flake.nixosConfigurations =
    lib.mkMerge (
      lib.mapAttrsToList
        (name: _: self.lib.mkMicroVM "x86_64-linux" name)
        self.modules.microvm
    );
}
{
  inputs,
  ...
}:
{
  flake.modules.nixos.server-profile = {
    imports = with inputs.self.modules.nixos; [
      base
      microvm-host
      network
      openssh
      sanoid
      zfs
    ];
  };
}

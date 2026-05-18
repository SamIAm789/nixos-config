{
  flake.modules.nixos.server =
  {
    pkgs,
    ...
  }:
  {

    services.sanoid.datasets = {

      "stuff/immich" = {
        useTemplate = [ "production" ];
      };
      "stuff/ocis" = {
        useTemplate = [ "production" ];
      };
      "stuff/paperless" = {
        useTemplate = [ "production" ];
      };
      "stuff/photos" = {
        useTemplate = [ "production" ];
      };
    };

    # Needed for syncoid
    environment.systemPackages = [
      pkgs.lzop
      pkgs.mbuffer
    ];
  };
}

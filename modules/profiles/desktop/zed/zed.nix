{
  flake.modules.homeManager.zed = {

    { config, pkgs, lib, ... }:
  
  programs.zed-editor = {
    enable = true;
  };
}

{

  flake.modules.homeManager.zed = {

    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "docker-compose"
        "yaml"
      ];
    };
  };
}

{
  flake.modules.homeManager.zed = {
    programs.zed-editor.userSettings.settings.lsp = {
      nil = {
        binary = {
          path_lookup = true;
        };
        settings = {
          formatting = {
            command = ["alejandra"];
          };
          diagnostics = {
            ignored = [
              "unused_binding"
            ];
          };
        };
      };
    };
  };
}

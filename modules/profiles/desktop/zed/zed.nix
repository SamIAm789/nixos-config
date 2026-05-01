{

  let
    extentions = import ./extensions.nix;
    terminal = import ./terminal.nix;
    lsp = import ./lsp.nix;
    settings = import ./settings.nix;
  in 
    flake.modules.homeManager.zed = {

  programs.zed-editor = {
    enable = true;
    extensions = extentions;
    userSettings =
      settings
      // {
        terminal = terminal;
        lsp = lsp;
      };
    };
  };
}

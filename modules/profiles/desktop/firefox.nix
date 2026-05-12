{
  flake.modules.nixos.firefox = {

    programs.firefox = {
      enable = true;
      policies = {
       Containers = {
         Default = [
           {
             name = "personal";
             icon = "circle";
             color = "blue";
           }
           {
             name = "QHealth";
             icon = "briefcase";
             color = "red";
           }
           {
             name = "UnitingCare";
             icon = "briefcase";
             color = "purple";
           }
         ];
       };
       ExtensionSettings = {
         # https://mozilla.github.io/policy-templates/#extensionsettings
         # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
         #uBlock origin
         "uBlock0@raymondhill.net" = {
           default_area = "menupanel";
           install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
           installation_mode = "force_installed";
           private_browsing = true;
         };
         # absolute enable right clock and copy
         "{9350bc42-47fb-4598-ae0f-825e3dd9ceba}" = {
           install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/absolute-enable-right-click/latest.xpi";
           installation_mode = "force_installed";
           private_browsing = true;
         };
         # bitwarden
         "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
           install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
           installation_mode = "force_installed";
           private_browsing = true;
         };
         #multiaccount containers
         "@testpilot-containers" = {
           install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/multi-account-containers/latest.xpi";
           installation_mode = "force_installed";
           private_browsing = true;
         };
         # dark reader
         "addon@darkreader.org" = {
           install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/darkreader/latest.xpi";
           installation_mode = "force_installed";
           private_browsing = true;
         };
       };
       SearchEngines.Add = [
         {
           Name = "Nixos Packages";
           URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
           Method = "GET"; # "POST"
           IconURL = "https://search.nixos.org/favicon.png";
         }
         {
           Name = "Nixos Options";
           URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
           Method = "GET"; # "POST"
           IconURL = "https://search.nixos.org/favicon.png";
         }
         {
           Name = "Home Manager Options";
           URLTemplate = "https://home-manager-options.extranix.com/?query=&release=master";
           Method = "GET";
           IconURL = "https://search.nixos.org/favicon.png";
         }
       ];
      };
    };
  };
}

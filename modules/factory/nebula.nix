{
  config.flake.factory.user = username: isAdmin: {

    darwin."${username}" = {
      users.users."${username}" = {
        name = "${username}";
      };
      system.primaryUser = lib.mkIf isAdmin "${username}";
    };

    nixos."${username}" = {
      users.users."${username}" = {
        name = "${username}";
      };
      extraGroups = lib.optionals isAdmin [ "wheel" ];
    };
  };
}

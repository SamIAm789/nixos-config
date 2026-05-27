{
  description = "Imperative MicroVMs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:denful/import-tree";

    microvm = {
      url = "github:astro/microvm.nix";
      nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "github:SamIAm789/secrets";
      nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:SamIAm789/dotfiles";
      nixpkgs.follows = "nixpkgs";
      sops-nix.follows = "sops-nix";
      secrets.follows = "secrets";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules);
}

{
  description = "Home Manager configuration of whs";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  inputs."user.js".url = "github:arkenfox/user.js";
  inputs.fenix.url = "github:nix-community/fenix";
  inputs.nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  inputs.nixpkgs-mozilla.url = "github:whs-dot-hk/nixpkgs-mozilla/test";
  inputs.nur.url = "github:nix-community/nur";

  inputs."user.js".flake = false;

  outputs = {
    home-manager,
    nix-vscode-extensions,
    nixpkgs,
    nixpkgs-mozilla,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        nix-vscode-extensions.overlays.default
        nixpkgs-mozilla.overlays.firefox
      ];
    };
  in {
    homeConfigurations."whs" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {inherit inputs;};
    };
    homeConfigurations."packer" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home-packer.nix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {inherit inputs;};
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}

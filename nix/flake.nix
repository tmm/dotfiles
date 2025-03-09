{
  description = "home";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixoS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs:
    let
      username = "tmm";
    in
    {
      darwinConfigurations.${username} = inputs.darwin.lib.darwinSystem {
        specialArgs = {
          inherit username;
        };
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [
          ./modules/darwin.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = import ./modules/home-manager.nix;
              extraSpecialArgs = {
                pkgsUnstable = import inputs.nixpkgs-unstable {
                  system = "aarch64-darwin";
                };
              };
            };
          }
        ];
      };
    };
}

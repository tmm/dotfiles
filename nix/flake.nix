{
  description = "home";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:nix-darwin/nix-darwin/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    inputs:
    let
      dotfilesDir = "Developer/dotfiles";
      hosts = {
        tmm = {
          profile = "personal";
          system = "aarch64-darwin";
          username = "tmm";
          git = {
            name = "tmm";
            email = "tmm@tmm.dev";
            githubUser = "tmm";
            signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuIScU+299QwZ5IkK48wS6Fi713aruyZTGE1NILUTJ8";
            signingProgram = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          };
        };
        tmm-work = {
          profile = "work";
          system = "aarch64-darwin";
          username = "tmm";
          git = {
            name = "tmm";
            email = "tmm@tmm.dev";
            githubUser = "tmm";
            signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuIScU+299QwZ5IkK48wS6Fi713aruyZTGE1NILUTJ8";
            signingProgram = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          };
        };
      };
      mkDarwinConfiguration =
        hostName: host:
        let
          hostModule = ./hosts + "/${hostName}.nix";
          pkgs = import inputs.nixpkgs {
            inherit (host) system;
            config.allowUnfree = true;
          };
        in
        inputs.darwin.lib.darwinSystem {
          inherit pkgs;
          inherit (host) system;
          specialArgs = {
            inherit dotfilesDir host hostName;
          };
          modules = [
            ./modules/darwin.nix
          ]
          ++ (if builtins.pathExists hostModule then [ hostModule ] else [ ])
          ++ [
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${host.username} = import ./modules/home-manager.nix;
                extraSpecialArgs = {
                  inherit dotfilesDir host hostName;
                };
              };
            }
          ];
        };
    in
    {
      darwinConfigurations = builtins.mapAttrs mkDarwinConfiguration hosts;
    };
}

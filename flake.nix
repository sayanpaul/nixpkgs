{
  description = "Sayan's personal system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    ...
  }: {
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;

    darwinConfigurations = {
      "Sayans-MacBook-Pro" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sayanpaul = import ./home.nix;
          }
        ];
      };
    };
  };
}

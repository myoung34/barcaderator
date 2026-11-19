{
  description = "Barcaderator";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # nix build .#ledspicer
    packages.${system}.ledspicer = pkgs.callPackage ./pkgs/ledspicer {};

    overlays.default = final: _prev: {
      ledspicer = final.callPackage ./pkgs/ledspicer {};
    };

    formatter.${system} = pkgs.alejandra;

    # sudo nixos-rebuild switch --flake .#barcaderator
    nixosConfigurations.barcaderator = nixpkgs.lib.nixosSystem {
      modules = [
        {nixpkgs.overlays = [self.overlays.default];}
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.users.barcaderator = ./home-manager/home.nix;
        }
      ];
    };
  };
}

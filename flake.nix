{
  description = "system flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
  };
  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs: {
    nixosConfigurations.roux = nixpkgs.lib.nixosSystem {
	specialArgs = { inherit inputs; };
	modules = [ 
	    ./configuration.nix
	];
    };
  };
}

{
  description = "First Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.roux = nixpkgs.lib.nixosSystem {
	modules = [ 
	    ./configuration.nix
	];
    };
  };
}

let
  niv         = import ./nix/sources.nix {};
  haskellNix  = import niv.${"haskell.nix"} {};
  nixpkgsSrc  = haskellNix.sources.nixpkgs-2003;
  nixpkgsArgs = haskellNix.nixpkgsArgs;
in
import nixpkgsSrc nixpkgsArgs

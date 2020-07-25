{ compiler ? "ghc883"
, pkgs ? import ./nixpkgs.nix
}:
pkgs.haskell-nix.project {

  src = pkgs.haskell-nix.haskellLib.cleanGit {
    name = "PROJECT";
    src = ./.;
  };

  compiler-nix-name = compiler;

}

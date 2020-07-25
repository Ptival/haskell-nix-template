{ compiler ? "ghc883"
, pkgs ? import ./nixpkgs.nix
}:
let

  sources = import ./nix/sources.nix {};

  projectPackage = import ./default.nix {};

  packagesWithMyCabalHashes = pkgs.haskell.packages.${compiler}
    .override({ all-cabal-hashes = pkgs.fetchurl { inherit (sources.all-cabal-hashes) url sha256; }; });

  myHaskellPackages = packagesWithMyCabalHashes
    .extend (selfHaskell: superHaskell:
      let
        fromNiv = pkg: selfHaskell.callCabal2nix pkg (pkgs.fetchzip { inherit (sources.${pkg}) url sha256; }) {};
        dontCheck = pkgs.haskell.lib.dontCheck;
      in
        {

          brittany = dontCheck (selfHaskell.callHackage "brittany" "0.12.1.1" {});
          butcher = dontCheck (selfHaskell.callHackage "butcher" "1.3.3.2" {});
          extra = dontCheck (selfHaskell.callHackage "extra" "1.7.4" {});
          floskell = dontCheck (selfHaskell.callHackage "floskell" "0.10.3" {});
          ghc-check = selfHaskell.callHackage "ghc-check" "0.5.0.1" {};
          ghc-exactprint = selfHaskell.callHackage "ghc-exactprint" "0.6.2" {};
          ghc-lib-parser = selfHaskell.callHackage "ghc-lib-parser" "8.10.1.20200523" {};
          ghcide = dontCheck (fromNiv "ghcide");
          haskell-language-server = dontCheck (fromNiv "haskell-language-server");
          haskell-lsp = selfHaskell.callHackage "haskell-lsp" "0.22.0.0" {};
          haskell-lsp-types = selfHaskell.callHackage "haskell-lsp-types" "0.22.0.0" {};
          hie-bios = dontCheck (selfHaskell.callHackage "hie-bios" "0.6.1" {});
          hslogger = selfHaskell.callHackage "hslogger" "1.3.1.0" {};
          lsp-test = dontCheck (selfHaskell.callHackage "lsp-test" "0.11.0.2" {});
          network = dontCheck (selfHaskell.callHackage "network" "2.8.0.1" {});
          opentelemetry = selfHaskell.callHackage "opentelemetry" "0.4.2" {};
          ormolu = selfHaskell.callHackage "ormolu" "0.1.2.0" {};
          parser-combinators = selfHaskell.callHackage "parser-combinators" "1.2.1" {};
          stylish-haskell = selfHaskell.callHackage "stylish-haskell" "0.11.0.0" {};

          monad-dijkstra = selfHaskell.callHackageDirect {
            pkg = "monad-dijkstra";
            ver = "0.1.1.3";
            sha256 = "sha256:0b8yj2p6f0h210hmp9pnk42jzrrhc4apa0d5a6hpa31g66jxigy8";
          } {};

        });


in
projectPackage.shellFor {

  packages = ps: with ps; [
    nix-playground
  ];

  withHoogle = true;

  tools = {
    cabal = "3.2.0.0";
    hlint = "2.2.11";
    hpack = "0.34.2";
  };

  buildInputs =
    [
      myHaskellPackages.haskell-language-server
    ];

  exactDeps = true;

}

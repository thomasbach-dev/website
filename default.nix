{ nixpkgs ? import <nixpkgs> {}, compiler ? "default"}:
let
  inherit (nixpkgs) pkgs;
  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};
  website = haskellPackages.callPackage ./website.nix {};
in
nixpkgs.stdenv.mkDerivation {
  name = "thomas-bach.dev-website";
  buildInputs = [ website ];
  src = ./.;
  buildPhase = ''
    site build
    '';
  installPhase = ''
    mkdir $out
    cp -R _site/* $out
    '';
}

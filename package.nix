{ pkgs ? import <nixpkgs> {}
, stdenv ? pkgs.stdenv
, ...
}:


(
  stdenv.mkDerivation rec {
    name = "pimd";
    version = "2.3.2";
    src = pkgs.fetchurl {
      url = "https://github.com/troglobit/pimd/releases/download/${version}/pimd-${version}.tar.gz";
      sha256 = "sha256-x3qYEnUfEUSQoopoObFqrIsCDI2f1qoivziAwFThnx0=";
    };

    postPatch = ''
      substituteInPlace configure \
        --replace-fail '/bin/echo' 'echo'
    '';
  }
)

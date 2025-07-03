{ config
, lib
, pkgs
,...
}@args:

{
  imports = [
    ./options.nix
  ];
  options = {};

  config = import ./config.nix { inherit config lib pkgs; };
}

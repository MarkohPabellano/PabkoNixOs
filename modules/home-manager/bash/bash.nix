{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
  };

  home.file = {
    ".bashrc" = lib.mkForce {
      source = ./bashrc;  # Path to your custom .bashrc file
    };
  };
}
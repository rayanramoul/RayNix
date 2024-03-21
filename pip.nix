{ pkgs ? import <nixpkgs> {} }:
(pkgs.buildFHSUserEnv {
name = "pipzone";
targetPkgs = pkgs: (with pkgs; [
python39
python39Packages.pip
python39Packages.virtualenv
cudaPackages.cudatoolkit_11
]);
runScript = "bash";
}).env

# nix-shell pip.nix

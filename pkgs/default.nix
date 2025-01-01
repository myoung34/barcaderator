# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  backblaze-b2 = pkgs.callPackage ./backblaze-b2 {};
  ledspicer = pkgs.callPackage ./ledspicer {};
}

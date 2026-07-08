{
  description = "Tiny pandoc-based static site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            browser-sync
            gnumake
            pandoc
            watchexec
          ];

          shellHook = ''
            echo "pandoc site dev shell"
            echo "commands: make, make dev, make serve, make clean"
          '';
        };
      });
    };
}

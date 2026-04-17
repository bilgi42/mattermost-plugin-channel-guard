{
  description = "Mattermost Channel Guard plugin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        version = "0.1.2";
        pluginId = "com.mattermost.channel-guard";
      in
      {
        packages.default = pkgs.buildGoModule {
          pname = "mattermost-plugin-channel-guard";
          inherit version;
          src = ./.;
          subPackages = [ "server" ];

          vendorHash = "sha256-LBM+R6X5uN0jXqwTFZIM8UDuWjR+AdcjwRUGsm68zQA=";

          env.CGO_ENABLED = 0;

          buildPhase = ''
            runHook preBuild

            cd server
            for platform in linux-amd64 darwin-amd64; do
              GOOS=''${platform%%-*} GOARCH=''${platform##*-} go build -o dist/plugin-''${platform} .
            done
            GOOS=windows GOARCH=amd64 go build -o dist/plugin-windows-amd64.exe .
            cd ..

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/${pluginId}/server/dist
            cp plugin.json $out/${pluginId}/
            cp -r assets $out/${pluginId}/
            cp server/dist/* $out/${pluginId}/server/dist/

            cd $out
            tar -czf ${pluginId}-${version}.tar.gz ${pluginId}

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Mattermost plugin to guard channels from unauthorized posting";
            license = licenses.asl20;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ go gnumake ];
        };
      }
    );
}

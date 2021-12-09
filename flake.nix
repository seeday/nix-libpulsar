{
  description = "libpulsar: the c/c++ library for Apache Pulsar";

  inputs = {
    pulsar.url = "github:apache/pulsar/v2.8.1";
    pulsar.flake = false;
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, flake-utils, pulsar }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree {
          libpulsar = pkgs.stdenv.mkDerivation {
            name = "libpulsar";
            src = self.inputs.pulsar;

            # it is of course, undocumented that you need to lead with source/
            sourceRoot = "source/pulsar-client-cpp";

            nativeBuildInputs = with pkgs; [
              cmake
              openssl
              zlib
              curlMinimal
              boost
              python3
              python3Packages.boost
              protobuf
              zstd
              snappy
              gtest
            ];
          };
        };
        defaultPackage = packages.libpulsar;
      });
}

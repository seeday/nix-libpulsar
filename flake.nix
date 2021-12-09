{
  description = "libpulsar: the c/c++ library for Apache Pulsar";

  inputs = {
    pulsar.url = "github:apache/pulsar/v2.8.1";
    pulsar.flake = false;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, flake-utils, pulsar }: {
    defaultPackage.x86_64-linux =
      let pkgs = import nixpkgs { system = "x86_64-linux"; };
      in pkgs.stdenv.mkDerivation {
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
}

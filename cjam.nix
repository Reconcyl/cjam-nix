{ pkgs ? import <nixpkgs> {}
, stdenv ? pkgs.stdenv
, # we use a pretty old version of the JDK;
  # newer versions give errors about the project using deprecated "source option 6"
  jdk11 ? pkgs.jdk11_headless
, ant ? pkgs.ant
, jre ? pkgs.jre_minimal
, rlwrap ? pkgs.rlwrap
}:
let
  src = pkgs.fetchzip {
    name = "cjam-source";
    url = "https://master.dl.sourceforge.net/project/cjam/cjam-0.6.5/cjam-0.6.5-sources.zip?viasf=1";
    hash = "sha256-3fdLwvDiD7F7yXRRHoLiHj5yw6pmIQ2ZxrKg7GYvQYI=";
    extension = "zip";
    stripRoot = false;
  };

  cjam-jar = stdenv.mkDerivation {
    pname = "cjam";
    version = "0.6.5";
    inherit src;

    nativeBuildInputs = let P = pkgs; in [
      ant
      jdk11
      pkgs.stripJavaArchivesHook
      pkgs.makeWrapper
    ];

    buildPhase = ''
      runHook preBuild
      ant
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm644 build/cjam.jar $out/share/java/cjam.jar
      runHook postInstall
    '';
  };
in
  pkgs.writeShellApplication {
    name = "cjam";
    runtimeInputs = [ jre rlwrap ];
    text = ''
      java='java -cp ${cjam-jar}/share/java/cjam.jar'
      src='${src}'
    '' + builtins.readFile ./wrapper.sh;
  }

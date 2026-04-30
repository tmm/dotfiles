{ fetchurl, lib, stdenvNoCC }:
let
  version = "0.2.9";
  sources = {
    aarch64-darwin = {
      url = "https://github.com/lightpanda-io/browser/releases/download/${version}/lightpanda-aarch64-macos";
      hash = "sha256-9kVZsYmXbx6UAabFZ8RHnPHZ+DoZRLawSYQxd83LJbU=";
    };
    x86_64-darwin = {
      url = "https://github.com/lightpanda-io/browser/releases/download/${version}/lightpanda-x86_64-macos";
      hash = "sha256-NvvEXjMpX037PMvk8bjthXdKbwOZKSSF3NfkDdykqZ4=";
    };
    aarch64-linux = {
      url = "https://github.com/lightpanda-io/browser/releases/download/${version}/lightpanda-aarch64-linux";
      hash = "sha256-jKHb2a+6w2hGbpWmCHyyiFyoTN08YphxebiycL4SAic=";
    };
    x86_64-linux = {
      url = "https://github.com/lightpanda-io/browser/releases/download/${version}/lightpanda-x86_64-linux";
      hash = "sha256-VL65btP2Ob7MT9JjproKabYOXn4D72/lDZxjR6PqOV0=";
    };
  };
  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "lightpanda is unsupported on ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "lightpanda";
  inherit version;

  src = fetchurl source;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/lightpanda"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast headless browser with native automation support";
    homepage = "https://lightpanda.io";
    license = licenses.agpl3Only;
    mainProgram = "lightpanda";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}

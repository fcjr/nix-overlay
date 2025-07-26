{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "nrfutil";
  version = "8.0.0";

  src = fetchurl {
    url = "https://files.nordicsemi.com/ui/api/v1/download?repoKey=swtools&path=external/nrfutil/executables/aarch64-apple-darwin/nrfutil&isNativeBrowsing=false";
    hash = "sha256-hgq82LAm9hPnbnD4yZL7d/tZzLVFRv60bqMjLK5p9VQ=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    
    install -D $src $out/bin/nrfutil
    chmod +x $out/bin/nrfutil
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Unified command line utility for Nordic Semiconductor products";
    longDescription = ''
      nRF Util is a unified command line utility for Nordic products.
      It provides functionality through installable and upgradeable commands
      that are served on a central package registry.
    '';
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Util";
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
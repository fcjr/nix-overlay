{ lib, 
  fetchFromGitHub,
  cmake,
  python3,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "chameleon-ultra-cli";
  version = "7065011f228cbe54b7ce794697067bdec8e7f6b3";
  format = "other";
  
  src = fetchFromGitHub {
    owner = "RfidResearchGroup";
    repo = "ChameleonUltra";
    rev = "7065011f228cbe54b7ce794697067bdec8e7f6b3";
    sha256 = "unYvscgyiEIHZ+BrzeIXJIcmaDgbHd4mjaOfZWh+fjw=";
  };
  
  nativeBuildInputs = [
    makeWrapper
    cmake
  ];
  
  dependencies = with python3.pkgs; [
    pyserial
    colorama
    prompt-toolkit
  ];
  
  sourceRoot = "source/software";
  
  configurePhase = ''
    runHook preConfigure
    (
      mkdir -p src/out
      cd src/out
      cmake ..
    )
    runHook postConfigure
  '';
  
  buildPhase = ''
    runHook preBuild
    (
      cd src/out
      cmake --build . --config Release
    )
    runHook postBuild
  '';
  
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/chameleon-ultra
    cp -r ./script/* $out/lib/chameleon-ultra/
    
    makeWrapper ${python3}/bin/python $out/bin/chameleon-ultra-cli \
      --add-flags "$out/lib/chameleon-ultra/chameleon_cli_main.py" \
      --chdir "$out/lib/chameleon-ultra" \
      --prefix PATH : "$out/lib/chameleon-ultra" \
      --prefix PYTHONPATH : "${python3.pkgs.makePythonPath dependencies}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Command-line tool for ChameleonUltra RFID/NFC research device";
    longDescription = ''
      ChameleonUltra CLI is the official command-line interface for controlling
      the ChameleonUltra device, a portable tool for NFC security research.
      It provides functionality for RFID/NFC card emulation, sniffing, and analysis.
    '';
    homepage = "https://github.com/RfidResearchGroup/ChameleonUltra";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    mainProgram = "chameleon-ultra-cli";
  };
}
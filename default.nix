final: prev: {
  chameleon-ultra-cli = prev.callPackage ./chameleon-ultra-cli { };
  nrfutil = prev.callPackage ./nrfutil { };
  
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      chameleon-ultra-cli = final.chameleon-ultra-cli;
    })
  ];
}
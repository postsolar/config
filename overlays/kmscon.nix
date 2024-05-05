final: prev: {

  kmscon = prev.kmscon.overrideAttrs {
    src = prev.fetchFromGitHub {
      owner = "MacSlow";
      repo = "kmscon";
      rev = "77a21edfa497487ec7c2f8ae7247244a615b4951";
      hash = "";
    };
  };

}

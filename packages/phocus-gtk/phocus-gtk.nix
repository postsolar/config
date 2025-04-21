# keep in mind `colors` attrset is a sass injection so sass functions are allowed

{ stdenvNoCC, fetchFromGitHub, nodePackages, colors }:

stdenvNoCC.mkDerivation rec {

  pname = "phocus";

  version = "9eb6df5c5ec2a7dfdfaa0daa35fd61918c5c86c9";

  src = fetchFromGitHub {
    owner = "phocus";
    repo = "gtk";
    rev = version;
    sha256 = "sha256-To4AL4XmAoHOVjlHQZMy8OaMt4G7v1h48Ka1XbWUSLI=";
  };

  nativeBuildInputs = [ nodePackages.sass ];

  patches = [
    ./patches/gradients.diff
    ./patches/substitute.diff
    ./patches/remove-npm.diff
  ];

  postPatch =
    ''
    substituteInPlace scss/gtk-3.0/_colors.scss \
      --replace "@bg0@" "${colors.surface-strongest or "rgb(10, 10, 10)"}" \
      --replace "@bg1@" "${colors.surface-strong or "rgb(20, 20, 20)"}" \
      --replace "@bg2@" "${colors.surface-moderate or "rgb(28, 28, 28)"}" \
      --replace "@bg3@" "${colors.surface-weak or "rgb(34, 34, 34)"}" \
      --replace "@bg4@" "${colors.surface-weakest or "rgb(40, 40, 40)"}" \
      --replace "@fg0@" "${colors.white-strongest or "rgb(255, 255, 255)"}" \
      --replace "@fg1@" "${colors.white-strong or "rgba(255, 255, 255, 0.87)"}" \
      --replace "@fg2@" "${colors.white-moderate or "rgba(255, 255, 255, 0.34)"}" \
      --replace "@fg3@" "${colors.white-weak or "rgba(255, 255, 255, 0.14)"}" \
      --replace "@fg4@" "${colors.white-weakest or "rgba(255, 255, 255, 0.06)"}" \
      --replace "@red@" "${colors.red-normal or "rgb(218, 88, 88)"}"  \
      --replace "@lred@" "${colors.red-light or "rgb(227, 109, 109)"}" \
      --replace "@orange@" "${colors.orange-normal or "rgb(237, 148, 84)"}" \
      --replace "@lorange@" "${colors.orange-light or "rgb(252, 166, 105)"}" \
      --replace "@yellow@" "${colors.yellow-normal or "rgb(232, 202, 94)"}" \
      --replace "@lyellow@" "${colors.yellow-light or "rgb(250, 221, 117)"}" \
      --replace "@green@" "${colors.green-normal or "rgb(63, 198, 97)"}" \
      --replace "@lgreen@" "${colors.green-light or "rgb(97, 214, 126)"}" \
      --replace "@cyan@" "${colors.cyan-normal or "rgb(92, 216, 230)"}" \
      --replace "@lcyan@" "${colors.cyan-light or "rgb(126, 234, 246)"}" \
      --replace "@blue@" "${colors.blue-normal or "rgb(73, 126, 233)"}" \
      --replace "@lblue@" "${colors.blue-light or "rgb(93, 141, 238)"}" \
      --replace "@purple@" "${colors.purple-normal or "rgb(113, 84, 242)"}" \
      --replace "@lpurple@" "${colors.purple-light or "rgb(128, 102, 245)"}" \
      --replace "@pink@" "${colors.pink-normal or "rgb(213, 108, 195)"}" \
      --replace "@lpink@" "${colors.pink-light or "rgb(223, 129, 207)"}" \
      --replace "@primary@" '${colors.primary or "$purple-normal"}' \
      --replace "@secondary@" '${colors.secondary or "$green-normal"}'
    '';

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

}

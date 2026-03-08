{
  buildRPackage,
  fetchFromGitHub,
  ggplot2,
  magrittr,
  plotly,
}:

buildRPackage {
  name = "RadialMR-1.2.1";
  src = fetchFromGitHub {
    owner = "WSpiller";
    repo = "RadialMR";
    rev = "68570e12d80f12eaf2051487240f2c5f94e7ab5e";
    sha256 = "0isavnna1izjivj8lvigr5bz4xjdfyachfi309332xrx0fr4hqnb";
  };
  propagatedBuildInputs = [
    ggplot2
    magrittr
    plotly
  ];
}

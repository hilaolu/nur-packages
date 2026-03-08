{
  buildRPackage,
  fetchFromGitHub,
  cowplot,
  data_table,
  dplyr,
  ggplot2,
  glmnet,
  gridExtra,
  gtable,
  ieugwasr,
  jsonlite,
  knitr,
  lattice,
  magrittr,
  MASS,
  MRMix,
  MRPRESSO,
  pbapply,
  psych,
  RadialMR,
  reshape2,
  rmarkdown,
}:

buildRPackage {
  name = "TwoSampleMR-0.7.0";
  src = fetchFromGitHub {
    owner = "MRCIEU";
    repo = "TwoSampleMR";
    rev = "v0.7.0";
    sha256 = "1bjjbxyklgpykn16fgzh24s1pjhx7xl2plbbda8jbnlzdqrwvan2";
  };
  propagatedBuildInputs = [
    cowplot
    data_table
    dplyr
    ggplot2
    glmnet
    gridExtra
    gtable
    ieugwasr
    jsonlite
    knitr
    lattice
    magrittr
    MASS
    MRMix
    MRPRESSO
    pbapply
    psych
    RadialMR
    reshape2
    rmarkdown
  ];
}

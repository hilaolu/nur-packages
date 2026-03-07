{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  pandas,
  numpy,
  matplotlib,
  seaborn,
  scipy,
  pysam,
  biopython,
  adjusttext,
  h5py,
  pyarrow,
  polars,
  liftover,
  scikit-allel,
  gtfparse,
  requests,
  pyensembl,
}:

buildPythonPackage rec {
  pname = "gwaslab";
  version = "3.6.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+pcmK5T+G2XGESI2issxr7lbWNe7u7nGjiV/0BAig0w=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    pandas
    numpy
    matplotlib
    seaborn
    scipy
    pysam
    biopython
    adjusttext
    h5py
    pyarrow
    polars
    liftover
    scikit-allel
    gtfparse
    requests
    pyensembl
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"numpy>=1.21.2,<2"' '"numpy"' \
      --replace-fail '"matplotlib>=3.8,<3.9"' '"matplotlib"' \
      --replace-fail '"pySAM==0.22.1"' '"pySAM"' \
      --replace-fail '"adjustText>=0.7.3, <=0.8"' '"adjustText"' \
      --replace-fail '"gtfparse==1.3.0"' '"gtfparse"'

    sed -i 's/requires-python = ">=3.9,<3.13"/requires-python = ">=3.9"/' pyproject.toml
  '';

  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [
    "gwaslab"
  ];

  meta = {
    description = "A handy python package for gwas summary statistics handling and visualization";
    homepage = "https://cloufield.github.io/gwaslab/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}

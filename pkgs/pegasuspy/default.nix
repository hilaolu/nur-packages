{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools-scm,
  adjusttext,
  anndata,
  docopt,
  demuxEM,
  hnswlib,
  psutil,
  threadpoolctl,
  joblib,
  lightgbm,
  loompy,
  leidenalg,
  matplotlib,
  natsort,
  numba,
  numpy,
  pandas,
  pybind11,
  scikit-learn,
  scikit-misc,
  scipy,
  seaborn,
  statsmodels,
  umap-learn,
  wordcloud,
  xlsxwriter,
  igraph,
  zarr,
  pegasusio,
}:

buildPythonPackage rec {
  pname = "pegasuspy";
  version = "1.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilab-bcb";
    repo = "pegasus";
    rev = version;
    sha256 = "0xp0q4w901j1pckxbwqzajpqpakr3hqi5a06xhmq9ibz3l1rbcqb";
  };

  build-system = [
    cython
    setuptools-scm
  ];

  dependencies = [
    adjusttext
    anndata
    docopt
    demuxEM
    hnswlib
    psutil
    threadpoolctl
    joblib
    lightgbm
    loompy
    leidenalg
    matplotlib
    natsort
    numba
    numpy
    pandas
    pybind11
    scikit-learn
    scikit-misc
    scipy
    seaborn
    statsmodels
    umap-learn
    wordcloud
    xlsxwriter
    igraph
    zarr
    pegasusio
  ];

  doCheck = false;

  meta = {
    description = "Pegasus is a Python package for analyzing sc/snRNA-seq data of millions of cells";
    homepage = "https://github.com/lilab-bcb/pegasus";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}

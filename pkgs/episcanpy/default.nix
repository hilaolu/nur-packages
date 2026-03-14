{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  anndata,
  scanpy,
  intervaltree,
  matplotlib,
  pandas,
  scipy,
  seaborn,
  h5py,
  scikit-learn,
  statsmodels,
  networkx,
  natsort,
  joblib,
  numba,
  numpy,
  bamnostic,
  umap-learn,
  tqdm,
  legacy-api-wrap,
  packaging,
  pysam,
  kneed,
  biopython,
  pyjaspar,
  tbb,
  igraph,
  louvain ? null,
  leidenalg,
  patsy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "episcanpy";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lXORSdtgUhsKFORXn4uofUEBJv+3uRarvC0a/z30DOM=";
  };

  postPatch = ''
    substituteInPlace episcanpy/utils.py \
      --replace-fail "from distutils.version import LooseVersion" "from packaging.version import Version as LooseVersion"
    substituteInPlace episcanpy/__init__.py \
      --replace-fail "from anndata import read" "from anndata.io import read_h5ad as read"
    find episcanpy -name "*.py" -exec sed -i 's/\bNaN\b/nan/g' {} +
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    anndata
    scanpy
    intervaltree
    matplotlib
    pandas
    scipy
    seaborn
    h5py
    scikit-learn
    statsmodels
    networkx
    natsort
    joblib
    numba
    numpy
    bamnostic
    umap-learn
    tqdm
    legacy-api-wrap
    packaging
    pysam
    kneed
    biopython
    pyjaspar
    tbb
    setuptools
  ];

  optional-dependencies = {
    louvain = [
      igraph
      louvain
    ];
    leiden = [
      igraph
      leidenalg
    ];
    combat = [
      patsy
    ];
  };

  # Tests require large data files
  doCheck = false;

  env.NUMBA_CACHE_DIR = "/tmp";

  pythonImportsCheck = [
    "episcanpy"
  ];

  meta = {
    description = "Epigenomics extension for scanpy";
    homepage = "https://github.com/colomemaria/epiScanpy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}

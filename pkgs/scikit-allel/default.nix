{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  setuptools-scm,
  cython,
  numpy,
  scipy,
  matplotlib,
  seaborn,
  pandas,
  dask,
}:

buildPythonPackage rec {
  pname = "scikit-allel";
  version = "1.3.13";
  pyproject = true;

  src = fetchPypi {
    pname = "scikit_allel";
    inherit version;
    hash = "sha256-mji0zADTuprZl6qlfQ8D8zMeR3HjiJ8NnFhKDX9TPjU=";
  };

  build-system = [
    setuptools
    wheel
    setuptools-scm
    cython
  ];

  dependencies = [
    numpy
    scipy
    matplotlib
    seaborn
    pandas
    dask
  ];

  pythonImportsCheck = [
    "allel"
  ];

  meta = {
    description = "A Python package for exploring and analyzing large-scale genetic variation data";
    homepage = "https://github.com/cggh/scikit-allel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}

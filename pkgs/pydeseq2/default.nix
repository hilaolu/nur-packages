{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  anndata,
  formulaic,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  formulaic-contrasts,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "pydeseq2";
  version = "0.5.4";
  pyproject = true;

  src = fetchPypi {
    pname = "pydeseq2";
    inherit version;
    hash = "sha256-Sdb0eEC1RE6itpvnhXxsTljzaQZqD7JLxS99OmK72Sw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    anndata
    formulaic
    numpy
    pandas
    scikit-learn
    scipy
    formulaic-contrasts
    matplotlib
  ];

  pythonImportsCheck = [
    "pydeseq2"
  ];

  meta = {
    description = "A Python implementation of the DESeq2 method for differential expression analysis";
    homepage = "https://github.com/owkin/PyDESeq2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}

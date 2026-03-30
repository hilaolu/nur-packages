{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  anndata,
  docrep,
  lightning,
  ml-collections,
  mudata,
  numba,
  numpy,
  pandas,
  pyro-ppl,
  rich,
  scanpy,
  scikit-learn,
  scipy,
  sparse,
  tensorboard,
  torch,
  torchmetrics,
  tqdm,
  xarray,
  enableCuda ? false,
}:

buildPythonPackage rec {
  pname = "scvi-tools";
  version = "1.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "scvi_tools";
    inherit version;
    hash = "sha256-w9Lm5M19QfzNrurWPHKk2aFoG7UfKs4QdGEhehgutuI=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    anndata
    docrep
    lightning
    ml-collections
    mudata
    numba
    numpy
    pandas
    pyro-ppl
    rich
    scanpy
    scikit-learn
    scipy
    sparse
    tensorboard
    (torch.override { cudaSupport = enableCuda; })
    torchmetrics
    tqdm
    xarray
  ];

  doCheck = false;

  pythonImportsCheck = [
    "scvi"
  ];

  meta = {
    description = "Deep probabilistic analysis of single-cell omics data";
    homepage = "https://github.com/scverse/scvi-tools";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}

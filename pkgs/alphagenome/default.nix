{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
  grpcio-tools,
  importlib-resources,

  # dependencies
  absl-py,
  anndata,
  grpcio,
  immutabledict,
  intervaltree,
  jaxtyping,
  matplotlib,
  ml-dtypes,
  numpy,
  pandas,
  protobuf,
  pyarrow,
  scipy,
  seaborn,
  tqdm,
  typeguard,
  typing-extensions,
  zstandard,
}:

buildPythonPackage rec {
  pname = "alphagenome";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-58oh3LQx/6Ui1vkRrnl51fHh72PGISRNHgDbh174cDs=";
  };

  postPatch = ''
    # Relax grpcio-tools version constraint (nixpkgs has 1.76.0, package wants <=1.67.1)
    substituteInPlace pyproject.toml \
      --replace-fail 'grpcio-tools<=1.67.1' 'grpcio-tools'
  '';

  build-system = [
    hatchling
    grpcio-tools
    importlib-resources
  ];

  dependencies = [
    absl-py
    anndata
    grpcio
    immutabledict
    intervaltree
    jaxtyping
    matplotlib
    ml-dtypes
    numpy
    pandas
    protobuf
    pyarrow
    scipy
    seaborn
    tqdm
    typeguard
    typing-extensions
    zstandard
  ];

  pythonImportsCheck = [ "alphagenome" ];

  meta = {
    description = "A foundation model for the human genome";
    homepage = "https://github.com/google-deepmind/alphagenome";
    changelog = "https://github.com/google-deepmind/alphagenome/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

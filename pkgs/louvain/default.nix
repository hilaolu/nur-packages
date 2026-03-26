{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  pkg-config,
  setuptools,

  # dependencies
  igraph, # C library
  python-igraph,
  texttable,
}:

buildPythonPackage rec {
  pname = "louvain";
  version = "0.8.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zgQLsMXjSa6tWh5emXONzZ8tEMIlJtBjMoG2riMO6NQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  build-system = [
    setuptools
  ];

  buildInputs = [
    igraph
  ];

  dependencies = [
    python-igraph
    texttable
  ];

  pythonImportsCheck = [ "louvain" ];

  meta = {
    description = "Louvain Community Detection in Python";
    homepage = "https://github.com/vtraag/louvain-igraph";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
}

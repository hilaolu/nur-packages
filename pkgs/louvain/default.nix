{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  cmake,
  pkg-config,
  setuptools,
  setuptools-scm,

  # dependencies
  igraph, # C library
  python-igraph,
  texttable,

  # tests
  ddt,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "louvain";
  version = "0.8.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zgQLsMXjSa6tWh5emXONzZ8tEMIlJtBjMoG2riMO6NQ=";
  };

  # prevent the standard cmake configure phase from running at the root
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    igraph
  ];

  dependencies = [
    python-igraph
    texttable
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'igraph >= 0.10.0,< 0.12'" "'igraph >= 0.10.0'"
  '';

  # Force use of system igraph
  setupPyBuildFlags = [ "--external" "--use-pkg-config" ];

  nativeCheckInputs = [
    ddt
    pytestCheckHook
  ];

  pythonImportsCheck = [ "louvain" ];

  meta = {
    description = "Louvain Community Detection in Python";
    homepage = "https://github.com/vtraag/louvain-igraph";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  hatch-docstring-description,
}:

buildPythonPackage rec {
  pname = "session-info2";
  version = "0.4";
  pyproject = true;

  src = fetchPypi {
    pname = "session_info2";
    inherit version;
    hash = "sha256-uwG/fDIDAdbLz602uFzKe+/lN//WAmm+OK6eGpVvSqQ=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-docstring-description
  ];

  doCheck = false;

  pythonImportsCheck = [
    "session_info2"
  ];

  meta = {
    description = "Print versions of imported packages";
    homepage = "https://github.com/flying-sheep/session-info2";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}

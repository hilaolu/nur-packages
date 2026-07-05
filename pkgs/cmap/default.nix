{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  numpy,
}:

buildPythonPackage rec {
  pname = "cmap";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lQHOxNXCt6ghR5rsMoKz2LQv2pg7rQVeD528Gc97xbE=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "cmap" ];

  meta = {
    description = "Scientific colormaps for python, without dependencies";
    homepage = "https://github.com/pyapp-kit/cmap";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}

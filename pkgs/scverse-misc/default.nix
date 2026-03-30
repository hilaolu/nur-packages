{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  pandas,
  session-info2,
}:

buildPythonPackage rec {
  pname = "scverse-misc";
  version = "0.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "scverse_misc";
    inherit version;
    hash = "sha256-5Eyp9xxGjR1oqafJG97qNupr1M/NFsXv1fWhPHXFeDY=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pandas
    session-info2
  ];

  doCheck = false;

  pythonImportsCheck = [
    "scverse_misc"
  ];

  meta = {
    description = "Miscellaneous utility code used by scverse packages";
    homepage = "https://github.com/scverse/scverse-misc";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}

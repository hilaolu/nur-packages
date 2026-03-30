{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "hatch-docstring-description";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "hatch_docstring_description";
    inherit version;
    hash = "sha256-sV2TwnO6NzaryeLFQrtCpyimdAcD/17YXMBy7UlFiuM=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    hatchling
  ];

  doCheck = false;

  meta = {
    description = "A hatchling plugin to read the description from the package docstring";
    homepage = "https://github.com/flying-sheep/hatch-docstring-description";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}

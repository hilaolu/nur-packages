{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  formulaic,
  pandas,
  session-info,
}:

buildPythonPackage rec {
  pname = "formulaic-contrasts";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "formulaic_contrasts";
    inherit version;
    hash = "sha256-CldagQvx+6KJOCWdhqOuKukMuYJvyoS5QJCFFwhi9wE=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    formulaic
    pandas
    session-info
  ];

  pythonImportsCheck = [
    "formulaic_contrasts"
  ];

  meta = {
    description = "Build arbitrary contrasts for models defined with formulaic";
    homepage = "https://github.com/scverse/formulaic-contrasts";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}

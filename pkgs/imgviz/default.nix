{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  hatch-fancy-pypi-readme,
  matplotlib,
  numpy,
  pillow,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "imgviz";
  version = "1.7.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wkentaro";
    repo = "imgviz";
    rev = "v${version}";
    hash = "sha256-y77ML7kswFr1LuxlP5HRmMeoUBqm7OMYWwsOiLfl9nw=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pillow
    pyyaml
  ];

  pythonImportsCheck = [ "imgviz" ];

  meta = {
    description = "Image visualization tools";
    homepage = "https://github.com/wkentaro/imgviz";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

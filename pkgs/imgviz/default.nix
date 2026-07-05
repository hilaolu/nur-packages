{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  hatch-fancy-pypi-readme,
  cmap,
  numpy,
  pillow,
}:

buildPythonPackage rec {
  pname = "imgviz";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wkentaro";
    repo = "imgviz";
    rev = "v${version}";
    hash = "sha256-qPSUcxf3/n7LizDAkotg1nhBdxQY7bnWVuMPj8P2z0o=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [
    cmap
    numpy
    pillow
  ];

  pythonImportsCheck = [ "imgviz" ];

  meta = {
    description = "Image visualization tools";
    homepage = "https://github.com/wkentaro/imgviz";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

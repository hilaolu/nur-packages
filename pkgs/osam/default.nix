{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  hatch-fancy-pypi-readme,
  click,
  gdown,
  imgviz,
  loguru,
  onnxruntime,
  pillow,
  pydantic,
}:

buildPythonPackage rec {
  pname = "osam";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wkentaro";
    repo = "osam";
    rev = "v${version}";
    hash = "sha256-XJzH/nWA0bhNNej+qxqASrAljKENXYEevYQmzLyp7q0=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [
    click
    gdown
    imgviz
    loguru
    onnxruntime
    pillow
    pydantic
  ];

  pythonImportsCheck = [ "osam" ];

  meta = {
    description = "Get up and running vision foundational models locally";
    homepage = "https://github.com/wkentaro/osam";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "osam";
  };
}

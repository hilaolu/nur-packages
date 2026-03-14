{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bamnostic";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ew1PoXeS/TF7G3XB43p2SumEGfVAROeoAw7sfbpOWrg=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "A pure Python Binary Alignment Map (BAM) file parser";
    homepage = "https://github.com/Betteromics/bamnostic";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pandas,
  datacache,
  gtfparse,
  serializable,
  tinytimer,
  memoized-property,
}:

buildPythonPackage rec {
  pname = "pyensembl";
  version = "2.3.13";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xwznYPaP4qa+hx20TlPOHU0SJ/LOBXjGspHVqJ9dGDI=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    datacache
    gtfparse
    serializable
    tinytimer
    memoized-property
  ];

  # Tests require network or complex setup
  doCheck = false;

  meta = {
    description = "A Python interface to Ensembl's genomic feature data";
    homepage = "https://github.com/openvax/pyensembl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}

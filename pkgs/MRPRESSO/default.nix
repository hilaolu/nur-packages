{
  buildRPackage,
  fetchFromGitHub,
}:

buildRPackage {
  name = "MRPRESSO-1.0";
  src = fetchFromGitHub {
    owner = "rondolab";
    repo = "MR-PRESSO";
    rev = "3e3c92d7eda6dce0d1d66077373ec0f7ff4f7e87";
    sha256 = "16f13bz6iklbp2w4xkkf61klr7rpdqsh2vj6h0lrvvj9d5z60598";
  };
}

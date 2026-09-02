{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libiconv,
  onnxruntime,

  # build-system
  cffi,

  # dependencies
  ast-grep,
  click,
  fastapi,
  h2,
  httpx,
  litellm,
  magika,
  mcp,
  openai,
  opentelemetry-api,
  orjson,
  pydantic,
  pyyaml,
  rich,
  sqlite-vec,
  tiktoken,
  tomli,
  tomlkit,
  transformers,
  uvicorn,
  watchdog,
  websockets,
  zstandard,

  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "headroom-ai";
  version = "0.37.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chopratejas";
    repo = "headroom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-89Tkzx56QIZWfNWLaiPdMynZGOLPr5EAP5RnLSgvBsA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-iEvap6uLsAqCSv+l/S7K7osxL+yV7Y8pE6Dhaqt2AIA=";
  };

  postPatch = ''
    substituteInPlace headroom/cli/wrap.py \
      --replace-fail \
        'cmd = [sys.executable, "-m", "headroom.cli", "proxy", "--port", str(port)]' \
        'cmd = ["headroom", "proxy", "--port", str(port)]'
  '';

  nativeBuildInputs = [
    cffi
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [ onnxruntime ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  env.ORT_DYLIB_PATH = "${onnxruntime}/lib/libonnxruntime${stdenv.hostPlatform.extensions.sharedLibrary}";
  makeWrapperArgs = [
    "--set"
    "ORT_DYLIB_PATH"
    finalAttrs.env.ORT_DYLIB_PATH
  ];

  propagatedBuildInputs = [
    ast-grep
    click
    fastapi
    h2
    httpx
    litellm
    magika
    mcp
    onnxruntime
    openai
    opentelemetry-api
    orjson
    pydantic
    pyyaml
    rich
    sqlite-vec
    tiktoken
    tomlkit
    transformers
    uvicorn
    watchdog
    websockets
    zstandard
  ]
  ++ lib.optionals (lib.versionOlder "3.11" finalAttrs.pythonVersion or "3.11") [ tomli ];

  # Nixpkgs provides the equivalent native ast-grep executable rather than
  # the PyPI wrapper distribution.
  pythonRemoveDeps = [ "ast-grep-cli" ];
  pythonImportsCheck = [
    "headroom"
    "headroom._core"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Context optimization layer for LLM applications";
    homepage = "https://github.com/chopratejas/headroom";
    changelog = "https://github.com/chopratejas/headroom/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "headroom";
    platforms = lib.platforms.unix;
  };
})

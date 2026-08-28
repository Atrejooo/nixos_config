{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  dbus,
  libxcb,
  pkg-config,
  protobuf,
  openssl,
  cacert,
  gitMinimal,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
  llvmPackages,
  makeWrapper,
  librusty_v8 ? callPackage ./librusty_v8.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
  },

  # Extension(s) Dependencies
  python3,
  bash,
  # X11
  xdotool,
  wmctrl,
  xclip,
  xwininfo,
  # Wayland
  wtype,
  wl-clipboard,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "goose-cli";
  version = "1.48.0";

  src = fetchFromGitHub {
    owner = "aaif-goose";
    repo = "goose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8tKAAQdP9Rx7X0hEuCmSQ9sQQSYiXVMhJc2EQqIjaOY=";
  };

  cargoHash = "sha256-EaDg6cLqQpixZzD6TfJPVYl7O5/PWWMCTTypIC72+Sk=";

  cargoBuildFlags = [
    "--bin"
    "goose"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    dbus
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  env = {
    LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";
    RUSTY_V8_ARCHIVE = librusty_v8;
  };

  postFixup = ''
    wrapProgram $out/bin/goose \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            bash
            python3
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            # X11
            xdotool
            wmctrl
            xclip
            xwininfo
            # Wayland
            wtype
            wl-clipboard
          ]
        )
      }
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    cacert
    gitMinimal
  ];

  __darwinAllowLocalNetworking = true;

  doCheck = false;
  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source, extensible AI agent that goes beyond code suggestions - install, execute, edit, and test with any LLM";
    homepage = "https://github.com/aaif-goose/goose";
    changelog = "https://github.com/aaif-goose/goose/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "goose";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})

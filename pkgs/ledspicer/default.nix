{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  pulseaudio,
  libusb1,
  tinyxml-2,
  libpthreadstubs,
}:
stdenv.mkDerivation rec {
  pname = "ledspicer";
  version = "0.6.3.1";

  src = fetchFromGitHub {
    owner = "meduzapat";
    repo = "ledspicer";
    rev = version;
    hash = "sha256-PCtvwjyk0ESpJpz/r/+uZCxvPctYRvOi0/ffWe4kNso="; # pragma: allowlist secret
  };

  nativeBuildInputs = [autoreconfHook pkg-config];
  buildInputs = [pulseaudio libusb1 tinyxml-2 libpthreadstubs];

  # Bake in the writable data dir NixOS links to (see nixos/configuration.nix),
  # instead of the read-only $out/share.
  postPatch = ''
    find . -name Makefile.am -exec sed -i -r 's|-DPACKAGE_DATA_DIR=[^ ]*|-DPACKAGE_DATA_DIR=\\"/etc/ledspicer/data/\\"|' {} +
  '';

  configureFlags = ["--enable-pulseaudio" "--enable-pacled64" "--disable-alsaaudio"];

  meta = {
    description = "LEDSpicer for controlling RGB LEDs";
    homepage = "https://github.com/meduzapat/ledspicer";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ledspicerd";
  };
}

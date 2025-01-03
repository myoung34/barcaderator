{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, pulseaudio, libusb1, automake, autoconf, libtool, tinyxml-2, libpthreadstubs, alsa-lib}:

stdenv.mkDerivation rec {
  pname = "ledspicer";
  version = "0.6.3.1";

  src = fetchFromGitHub {
    owner = "meduzapat";
    repo = "ledspicer";
    rev = "${version}";
    sha256 = "sha256-PCtvwjyk0ESpJpz/r/+uZCxvPctYRvOi0/ffWe4kNso="; # pragma: allowlist secret
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [
    pulseaudio
    libusb1
    tinyxml-2
    automake
    autoconf
    libtool
    libpthreadstubs
    alsa-lib
  ];

  preConfigure = ''
    aclocal
    [ -d config ] || mkdir config
    [ -d m4 ] || mkdir m4
    autoreconf --force --install -I config -I m4
  '';

  configureFlags = [
    "--sysconfdir=$out/etc"
    "--enable-pulseaudio"
    "--enable-pacled64"
    "--disable-alsaaudio"
  ];

  buildPhase = ''
    export CXXFLAGS="-s -O3"
    ./configure --disable-static --disable-dependency-tracking --prefix=$out
    make
  '';

  installPhase = ''
    make DESTDIR=$out/../../.. install
  '';

  meta = with lib; {
    description = "LEDSpicer for controlling RGB LEDs";
    homepage = "https://github.com/meduzapat/ledspicer";
    license = licenses.gpl3Plus;
    mainProgram = "ledspicer";
  };
}

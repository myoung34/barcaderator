{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "barcaderator";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
    xkb.layout = "us";
  };
  services.displayManager.autoLogin = {
    enable = true;
    user = "barcaderator";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steam/Proton
  };

  users.users.barcaderator = {
    isNormalUser = true;
    description = "barcaderator";
    extraGroups = ["networkmanager" "wheel" "input"];
  };
  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    ripgrep
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # LED controllers (Ultimarc d209, fafa; Atmel 03eb) for ledspicerd.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="d209", GROUP="users", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="fafa", GROUP="users", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", GROUP="users", MODE="0666"
    KERNEL=="event*", MODE="0666", GROUP="input"
  '';

  # LEDSpicer has its data dir compiled in as /etc/ledspicer/data/ (see pkgs/ledspicer).
  environment.etc."ledspicer/data".source = ../ledspicer/data;

  environment.etc."xdg/autostart/attract.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Attract
    Exec=sh -c "sleep 10 && attract"
    Terminal=false
    X-GNOME-Autostart-enabled=true
    OnlyShowIn=XFCE;
  '';

  services.openssh.enable = true;

  # Release of the first install; don't bump on upgrades.
  system.stateVersion = "24.11";
}

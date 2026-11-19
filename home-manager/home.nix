{pkgs, ...}: let
  ledspicerConf = "/etc/ledspicer/data/ledspicer.conf";
  # No SDL mapping exists for the DragonRise encoders (0079:0006), so Steam games
  # don't see them as gamepads. Xbox arcade-stick layout: back row X Y RB LB
  # (buttons 1-4), front row A B RT LT (5-8), coin = back, start = start.
  # Scoped to Steam: a global SDL mapping would renumber MAME's buttons.
  steam = pkgs.steam.override {
    extraEnv.SDL_GAMECONTROLLERCONFIG = "03000000790000000600000010010000,DragonRise Arcade Encoder,x:b0,y:b1,rightshoulder:b2,leftshoulder:b3,a:b4,b:b5,righttrigger:b6,lefttrigger:b7,back:b8,start:b9,leftx:a0,lefty:a1,platform:Linux,";
  };
in {
  home = {
    username = "barcaderator";
    homeDirectory = "/home/barcaderator";
  };

  home.packages = with pkgs; [
    steam
    attract-mode
    mame
    pre-commit
    detect-secrets
    jq
    yq-go
    usbutils
    ledspicer
    # Attract-mode launches MAME through this so the buttons light per game.
    (writeShellScriptBin "mame-led" ''
      export PATH=${mame}/bin:$PATH # emitter runs `mame -lx <rom>`
      conf=${ledspicerConf}
      ${ledspicer}/bin/emitter -c "$conf" LoadProfileByEmulator "''${!#}" arcade || true
      mame "$@"
      rc=$?
      ${ledspicer}/bin/emitter -c "$conf" FinishLastProfile || true
      exit $rc
    '')
    # Same for Steam: light profiles/steam/<appid>.xml while the game runs.
    (writeShellScriptBin "steam-led" ''
      id=$1
      conf=${ledspicerConf}
      running() { ${procps}/bin/pgrep -f "[S]teamLaunch AppId=$id " >/dev/null; }
      ${ledspicer}/bin/emitter -c "$conf" LoadProfile "steam/$id" || true
      # Starts Steam if needed (then it keeps running), so don't wait on it.
      # -silent keeps a cold-started Steam's main window from covering Attract.
      ${steam}/bin/steam -silent "steam://rungameid/$id" &
      for _ in $(seq 180); do running && break; sleep 1; done
      # A first launch runs an install-script step, then the game, under
      # separate reapers; only stop once none comes back.
      while :; do
        while running; do sleep 2; done
        for _ in $(seq 30); do running && continue 2; sleep 1; done
        break
      done
      ${ledspicer}/bin/emitter -c "$conf" FinishLastProfile || true
    '')
  ];

  systemd.user.services.ledspicerd = {
    Unit.Description = "LEDSpicer button LED daemon";
    Service = {
      ExecStart = "${pkgs.ledspicer}/bin/ledspicerd -f -c ${ledspicerConf}";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.file = {
    ".attract" = {
      source = ../home/barcaderator/.attract;
      recursive = true;
    };
    ".mame" = {
      source = ../home/barcaderator/.mame;
      recursive = true;
    };
  };

  xfconf = {
    enable = true;
    settings = {
      xfce4-power-manager = {
        "xfce4-power-manager/blank-on-ac" = 0;
        "xfce4-power-manager/blank-on-battery" = 0;
        "xfce4-power-manager/dpms-enabled" = false;
        "xfce4-power-manager/lock-screen-suspend-hibernate" = false;
        "xfce4-power-manager/power-button-action" = 4; #shutdown on button press
        "xfce4-power-manager/show-tray-icon" = false;
      };
      xfce4-screensaver = {
        "lock/saver-activation/enabled" = false;
        "lock/user-switching/enabled" = false;
        "saver/idle-activation/enabled" = false;
        "saver/mode" = 0;
      };
      xfce4-session = {
        "general/SaveOnExit" = true;
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Mark Young";
      user.email = "myoung34@my.apsu.edu";
      alias = {
        co = "checkout";
        st = "status";
      };
      init.defaultBranch = "main";
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      pull.rebase = true;
      mergetool.prompt = "false";
    };
  };

  programs.google-chrome = {
    enable = true;
    commandLineArgs = [
      "--force-dark-mode"
      "--ignore-gpu-blocklist"
    ];
  };

  # Release of the first install; don't bump on upgrades.
  home.stateVersion = "24.11";
}

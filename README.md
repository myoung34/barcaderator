## Barcaderator ##

My NixOS build configuration for my arcade.

* Attract-mode + [mvscomplete layout](https://github.com/keilmillerjr/mvscomplete-layout)
* Mame
* Steam
* TODO: ledspicer for the buttons

![](images/barcade.gif)

### Pulling roms and generating metadata ###

To prevent violating github ToS my roms, snaps, and videos are in b2
To pull and generate the files:

```
export B2_APPLICATION_KEY_ID="changeme"
export B2_APPLICATION_KEY="changeme"

bash generate.sh
```

### Notes ###

Pre-req for home-manager:

```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

To run in general

```
sudo nixos-rebuild switch --flake .#barcaderator
home-manager switch --flake .#barcaderator@barcaderator
```

To delete old generations

```
nix-collect-garbage  --delete-old
# recommeneded to sometimes run as sudo to collect additional garbage
sudo nix-collect-garbage -d
# As a separation of concerns - you will need to run this command to clean out boot
sudo /run/current-system/bin/switch-to-configuration boot
```

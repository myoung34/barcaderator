## Barcaderator ##

My NixOS build configuration for my arcade.

* Attract-mode + [mvscomplete layout](https://github.com/keilmillerjr/mvscomplete-layout)
* Mame
* Steam
* LedSpicer for the buttons

![](images/barcade.gif)

### Pulling roms and generating metadata ###

To prevent violating github ToS my roms, snaps, and videos are in a fastly object store.
To pull them and generate the romlists (needs an `aws-vault` profile named `fastly`):

```
bash generate.sh
```

### Notes ###

Apply the system and home-manager config (home-manager runs as a NixOS module):

```
nixos-rebuild switch --sudo --flake .#barcaderator
```

Upgrade nixpkgs/home-manager:

```
nix flake update
nixos-rebuild switch --sudo --flake .#barcaderator
```

Garbage collection runs weekly (generations older than 30 days) and the boot
menu keeps 10 entries. To collect now:

```
sudo nix-collect-garbage --delete-older-than 30d
```

Steam's default compatibility tool must stay on Proton 9.0: newer Proton finds
no GPU on this box.

#!/bin/env bash

#steam snap files (images and videos)
mkdir -p home/barcaderator/.local/steam
pushd . >/dev/null
cd home/barcaderator/.local/steam
b2 sync b2://barcaderator/steam/ .
popd >/dev/null

echo $'#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons;Series;Language;Region;Rating' >./home/barcaderator/.attract/romlists/steam.txt
(find ./home/barcaderator/.local/steam/snap -type f -name '*.mp4' | sed 's/^.*\///g' | sed 's/\.mp4$//g' | while read -r steam_id; do
  # Query the Steam Store API
  response=$(curl -s "https://store.steampowered.com/api/appdetails?appids=$steam_id")

  # Sanitize the JSON by removing control characters
  sanitized_response=$(echo "$response" | tr -d '\000-\037')

  # Extract the game name
  game_name=$(echo "$sanitized_response" | jq -r ".[\"$steam_id\"].data.name" 2>/dev/null)

  # Check if the game name was retrieved
  if [[ -n "$game_name" && "$game_name" != "null" ]]; then
    echo "$steam_id;$game_name;steam;;;;;;;;;;;$game_name;;;;;;;"
  fi
done) >>./home/barcaderator/.attract/romlists/steam.txt

#mame snap files (images and videos)
mkdir -p home/barcaderator/.local/mame
pushd . >/dev/null
cd home/barcaderator/.local/mame
b2 sync b2://barcaderator/mame/ .
popd >/dev/null

echo $'#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons;Series;Language;Region;Rating'>./home/barcaderator/.attract/romlists/mame.txt
(for rom in $(find ./home/barcaderator/.local/mame/roms -maxdepth 1 -type f | sed 's/^.*\///g' | grep -v '^roms$' | sed 's/\.\(zip\|7z\)$//g'); do
  mame -listxml "$rom" | yq -p=xml -o=json | jq -r '
    .mame.machine[0] |
    ."+@name" + ";" +
    .description + ";mame;;" +
    .year + ";" +
    .manufacturer + ";;" +
    .input."+@players" + ";" +
    .display."+@rotate" + ";" +
    (if (.input.control | type) == "array" then
      .input.control[0]."+@type" + " (" + (.input.control[0]."+@ways" // "") + ")"
    else
      .input.control."+@type" + " (" + (.input.control."+@ways" // "") + ")"
    end) +
    ";good;1;raster;;;;1;;;;"'
done) 2>&1 | grep -v 'jq: error' | grep -v BIOS | grep -v '^neogeo;' | sort | uniq >>./home/barcaderator/.attract/romlists/mame.txt

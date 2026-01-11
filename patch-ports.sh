#!/usr/bin/env bash

# [!] IF YOUR STEAM PATH IS ELSEWHERE, PLEASE MODIFY THIS PATH.
# [!] IT SHOULD NOT BE ELSEWHERE.
MOD_PATH="$HOME/.local/share/Steam/steamapps/workshop/content/394360/3350890356"

echo "[*] Jumping into TFR mod folder."
cd "$MOD_PATH" || {
  echo "Mod folder not found! Check MOD_PATH."
  exit 1
}

echo "[*] Moving Leaders to leaders."
[ -d gfx/Leaders ] && mv gfx/Leaders gfx/leaders

echo "[*] Fixing filenames at gfx/leaders."
cd gfx/leaders || {
  echo "gfx/leaders not found!"
  exit 1
}

find . -type f | while read f; do
  dir=$(dirname "$f")
  base=$(basename "$f")

  newbase=$(echo "$base" |
    sed 's/  */ /g' |
    sed 's/ \+\././g' |
    tr 'A-Z' 'a-z' |
    sed 's/ /_/g' |
    sed 's/\.jpeg$/.png/i' |
    sed 's/\.png$/.png/i')

  if [ "$base" != "$newbase" ]; then
    echo "  Renaming: $base -> $newbase"
    mv "$f" "$dir/$newbase"
  fi
done

echo "[*] Patching interface references."
cd ../../

find . -type f \( -name "*.gfx" -o -name "*.gui" -o -name "*.txt" -o -name "*.asset" \) -print0 |
  xargs -0 perl -pi -e 's/\.PNG\b/.png/g; s/\.JPE?G\b/.png/ig'

echo "[*] Clearing cache."
rm -rf "$HOME/.local/share/Paradox Interactive/Hearts of Iron IV/gfx"

echo "[*] Patched portraits."

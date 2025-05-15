#!/bin/bash

# 1. Change path to project root
cd "$(dirname "$0")/.."

# 2. Create Icon Packs
dart run flutter_iconpicker:generate_packs --packs allMaterial

# 3. Build for Flutter Web
flutter build web --release --no-tree-shake-icons

# 4. Copy .woffs fonts into build folder
# Check if the build web was successful
if [ $? -eq 0 ]; then
    # Create the font folder if it doesn't exists
    mkdir -p build/web/assets/fonts/woff2

    TARGET_DIR="build/web/assets/fonts/woff2"

    # Alle .woff2 Dateien in den Quellordnern durchgehen
    for font in assets/fonts/woff2/**/*.woff2; do
         # Extrahiere den Namen der Font-Familie aus dem Dateipfad
         FONT_FAMILY=$(dirname "$font" | xargs basename)
    
        # Erstelle das Zielverzeichnis für die Font-Familie, falls es nicht existiert
        mkdir -p "$TARGET_DIR/$FONT_FAMILY"

        # Kopiere die Datei in das Zielverzeichnis der Font-Familie
        cp "$font" "$TARGET_DIR/$FONT_FAMILY/"
    done

else
    echo "Flutter build failed!"
    exit 1
fi
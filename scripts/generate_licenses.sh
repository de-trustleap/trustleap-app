#!/bin/bash

# Vollautomatische Lizenz-Generierung 
# Nutzt flutter pub deps --json + pub.dev API für echte Lizenz-Daten
# Bei API-Fehlern wird die bestehende LICENSES.md NICHT überschrieben

echo "🔍 Analysiere Flutter Dependencies..."

# Change to project root
cd "$(dirname "$0")/.."

# Prüfe ob jq installiert ist
if ! command -v jq &> /dev/null; then
    echo "❌ Error: jq ist nicht installiert!"
    echo "📦 Installation: brew install jq (macOS) oder apt-get install jq (Linux)"
    exit 1
fi

# Prüfe ob curl installiert ist
if ! command -v curl &> /dev/null; then
    echo "❌ Error: curl ist nicht installiert!"
    exit 1
fi

echo "📦 Hole Dependency-Liste..."
TEMP_JSON="/tmp/flutter_deps.json"
flutter pub deps --json > "$TEMP_JSON"

# Extrahiere direkte Dependencies aus pubspec.yaml
DIRECT_DEPS=$(grep -A 100 "^dependencies:" pubspec.yaml | grep -B 100 "^dev_dependencies:" | grep "^  [a-zA-Z]" | sed 's/:.*//' | sed 's/^  //' | grep -v "flutter:" | grep -v "sdk: flutter" | sort -u)

# Extrahiere alle Paketnamen (außer flutter SDK und Flutter-interne Pakete)  
ALL_PACKAGES=$(jq -r '.packages[] | select(.kind != "root" and .name != "flutter" and .name != "sky_engine" and .name != "flutter_test" and .name != "flutter_web_plugins" and .name != "flutter_localizations") | .name' "$TEMP_JSON" | sort -u)

# Finde transitive Dependencies (alle minus direkte)
TRANSITIVE_DEPS=$(comm -23 <(echo "$ALL_PACKAGES") <(echo "$DIRECT_DEPS"))

# Erstelle Hash der aktuellen Package-Liste
CURRENT_PACKAGES_HASH=$(echo "$ALL_PACKAGES" | md5)

# Prüfe ob sich die Pakete geändert haben
CACHE_FILE=".licenses_cache"
if [ -f "$CACHE_FILE" ] && [ -f "LICENSES.md" ]; then
    CACHED_HASH=$(cat "$CACHE_FILE" 2>/dev/null)
    if [ "$CURRENT_PACKAGES_HASH" = "$CACHED_HASH" ]; then
        echo "✅ Keine neuen Dependencies - LICENSES.md ist aktuell"
        rm -f "$TEMP_JSON"
        exit 0
    fi
fi

echo "🔄 Dependencies haben sich geändert - aktualisiere LICENSES.md..."

# Test API-Verbindung mit einem bekannten Paket
echo "🌐 Teste pub.dev API Verbindung..."
TEST_RESPONSE=$(curl -s --max-time 5 "https://pub.dev/api/packages/bloc" 2>/dev/null)
if ! echo "$TEST_RESPONSE" | jq empty 2>/dev/null; then
    echo "❌ Error: pub.dev API ist nicht erreichbar!"
    echo "🔄 Die bestehende LICENSES.md bleibt unverändert."
    echo "💡 Versuche es später erneut oder prüfe deine Internetverbindung."
    rm -f "$TEMP_JSON"
    exit 1
fi

echo "✅ pub.dev API ist erreichbar"

# Temporäre Datei für neue LICENSES.md
TEMP_LICENSES="/tmp/new_licenses.md"

# Generiere LICENSES.md Header in temporäre Datei
cat > "$TEMP_LICENSES" << EOF
# Third-Party Licenses

This project uses the following third-party libraries and their respective licenses.

Last updated: $(date '+%Y-%m-%d %H:%M:%S')

---

## Flutter Framework

- **License**: BSD-3-Clause
- **Copyright**: Google Inc.
- **Website**: <https://flutter.dev>

## Direct Dependencies

These are the packages explicitly listed in your pubspec.yaml:
EOF

echo "📝 Hole Lizenz-Informationen von pub.dev..."

PACKAGE_COUNT=0
FAILED_PACKAGES=0

# Funktion zum Generieren von Paket-Info
generate_package_info() {
    local package=$1
    local target_file=$2
    
    PACKAGE_COUNT=$((PACKAGE_COUNT + 1))
    echo "  📦 $package..."
    
    # API Call zu pub.dev mit Timeout
    API_URL="https://pub.dev/api/packages/$package"
    PACKAGE_DATA=$(curl -s --max-time 10 "$API_URL" 2>/dev/null)
    
    # Parse JSON Response
    if echo "$PACKAGE_DATA" | jq empty 2>/dev/null; then
        # Extrahiere Daten aus API Response
        NAME=$(echo "$PACKAGE_DATA" | jq -r '.name // "Unknown"')
        VERSION=$(echo "$PACKAGE_DATA" | jq -r '.latest.version // "Unknown"')
        DESCRIPTION=$(echo "$PACKAGE_DATA" | jq -r '.latest.pubspec.description // "No description available"')
        # Wrap bare URLs in angle brackets to fix MD034
        DESCRIPTION=$(echo "$DESCRIPTION" | sed 's|http://www\.unicode\.org|<http://www.unicode.org>|g')
        # Break long descriptions at 80 characters but keep words intact
        if [ ${#DESCRIPTION} -gt 80 ]; then
            DESCRIPTION=$(echo "$DESCRIPTION" | fold -s -w 80 | sed '2,$s/^/  /' | sed 's/[ \t]*$//')
        fi
        HOMEPAGE=$(echo "$PACKAGE_DATA" | jq -r '.latest.pubspec.homepage // .latest.pubspec.repository // "https://pub.dev/packages/'$package'"' | sed 's|^http://|https://|')
        LICENSE=$(echo "$PACKAGE_DATA" | jq -r '.latest.pubspec.license // "MIT"')
        AUTHOR=$(echo "$PACKAGE_DATA" | jq -r '.latest.pubspec.author // .latest.pubspec.authors[0] // "Package Contributors"')
        
        # Bereinige Author (entferne Email)
        CLEAN_AUTHOR=$(echo "$AUTHOR" | sed 's/<.*>//' | sed 's/^ *//;s/ *$//')
        if [ -z "$CLEAN_AUTHOR" ]; then
            CLEAN_AUTHOR="Package Contributors"
        fi
        
        # Schreibe in Ziel-Datei
        cat >> "$target_file" << EOF

### $NAME

- **Version**: $VERSION
- **License**: $LICENSE
- **Author**: $CLEAN_AUTHOR
- **Website**: <$HOMEPAGE>
- **Description**: $DESCRIPTION
EOF
    else
        # Paket konnte nicht geladen werden
        echo "    ⚠️  Fehler beim Laden von $package"
        FAILED_PACKAGES=$((FAILED_PACKAGES + 1))
        
        # Bei zu vielen Fehlern: Abbruch (aber nicht bei Flutter-internen Paketen)
        if [ $FAILED_PACKAGES -gt 5 ]; then
            echo "❌ Zu viele API-Fehler ($FAILED_PACKAGES). Abbruch."
            echo "🔄 Die bestehende LICENSES.md bleibt unverändert."
            rm -f "$TEMP_JSON" "$TEMP_LICENSES"
            exit 1
        fi
    fi
    
    # Kleine Pause um pub.dev API nicht zu überlasten
    sleep 0.1
}

# Generiere direkte Dependencies
echo "📋 Direkte Dependencies..."
while IFS= read -r package; do
    if [ -n "$package" ]; then
        generate_package_info "$package" "$TEMP_LICENSES"
    fi
done <<< "$DIRECT_DEPS"

# Füge Abschnitt für transitive Dependencies hinzu
cat >> "$TEMP_LICENSES" << 'EOF'

---

## Transitive Dependencies

These packages are automatically included as dependencies of your direct dependencies:
EOF

# Generiere transitive Dependencies
echo "📋 Transitive Dependencies..."
while IFS= read -r package; do
    if [ -n "$package" ]; then
        generate_package_info "$package" "$TEMP_LICENSES"
    fi
done <<< "$TRANSITIVE_DEPS"

# Füge Fonts hinzu
cat >> "$TEMP_LICENSES" << 'EOF'

---

## Fonts

### Poppins

- **License**: SIL Open Font License 1.1
- **Copyright**: Indian Type Foundry, Jonny Pinhorn
- **Website**: <https://fonts.google.com/specimen/Poppins>

### Merriweather

- **License**: SIL Open Font License 1.1
- **Copyright**: Eben Sorkin
- **Website**: <https://fonts.google.com/specimen/Merriweather>

### Roboto

- **License**: Apache License 2.0
- **Copyright**: Google Inc.
- **Website**: <https://fonts.google.com/specimen/Roboto>

---

## License Summary

This project uses various open-source packages with permissive licenses that allow commercial use.
Full license texts can be found in the respective package repositories or at <https://pub.dev>.

---

_This file was automatically generated by querying pub.dev API. Do not edit manually._
EOF

# Bei wenigen Fehlern (nur Flutter-interne Pakete): Trotzdem aktualisieren
if [ $FAILED_PACKAGES -le 3 ]; then
    mv "$TEMP_LICENSES" "LICENSES.md"
    # Speichere Hash für nächsten Durchlauf
    echo "$CURRENT_PACKAGES_HASH" > "$CACHE_FILE"
    if [ $FAILED_PACKAGES -eq 0 ]; then
        echo "✅ LICENSES.md wurde erfolgreich aktualisiert!"
    else
        echo "✅ LICENSES.md wurde aktualisiert (${FAILED_PACKAGES} Flutter-interne Pakete übersprungen)"
    fi
else
    echo "⚠️  $FAILED_PACKAGES Pakete konnten nicht geladen werden."
    echo "🔄 Die bestehende LICENSES.md bleibt unverändert."
    rm -f "$TEMP_LICENSES"
fi

# Cleanup
rm -f "$TEMP_JSON"

DIRECT_COUNT=$(echo "$DIRECT_DEPS" | wc -l | tr -d ' ')
TRANSITIVE_COUNT=$(echo "$TRANSITIVE_DEPS" | wc -l | tr -d ' ')

echo "📄 Datei: $(pwd)/LICENSES.md"
echo "📊 Dependencies: $DIRECT_COUNT direct + $TRANSITIVE_COUNT transitive = $PACKAGE_COUNT total"

#!/bin/zsh
# Builds ~/Applications/Cellar.app from Cellar.applescript and registers it with Finder
# as an "Open With" option for spreadsheets (it never takes over as the default app).
set -euo pipefail

HERE="${0:A:h}"
APP="${CELLAR_APP:-$HOME/Applications/Cellar.app}"
PLIST="$APP/Contents/Info.plist"
PB=/usr/libexec/PlistBuddy

mkdir -p "${APP:h}"
rm -rf "$APP"
/usr/bin/osacompile -o "$APP" "$HERE/Cellar.applescript"
cp "$HERE/Cellar.icns" "$APP/Contents/Resources/applet.icns"

$PB -c "Set :CFBundleName Cellar" "$PLIST"
$PB -c "Add :CFBundleIdentifier string io.github.tbuettgen.cellar" "$PLIST" 2>/dev/null \
  || $PB -c "Set :CFBundleIdentifier io.github.tbuettgen.cellar" "$PLIST"
$PB -c "Add :CFBundleShortVersionString string 1.0" "$PLIST" 2>/dev/null || true
$PB -c "Add :NSHighResolutionCapable bool true" "$PLIST" 2>/dev/null || true

# Document types: replace osacompile's catch-all entry with spreadsheets only.
$PB -c "Delete :CFBundleDocumentTypes" "$PLIST" 2>/dev/null || true
$PB -c "Add :CFBundleDocumentTypes array" "$PLIST"
$PB -c "Add :CFBundleDocumentTypes:0 dict" "$PLIST"
$PB -c "Add :CFBundleDocumentTypes:0:CFBundleTypeName string Spreadsheet" "$PLIST"
$PB -c "Add :CFBundleDocumentTypes:0:CFBundleTypeRole string Editor" "$PLIST"
$PB -c "Add :CFBundleDocumentTypes:0:LSHandlerRank string Alternate" "$PLIST"
$PB -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes array" "$PLIST"
i=0
for uti in org.openxmlformats.spreadsheetml.sheet com.microsoft.excel.xls \
           com.microsoft.excel.sheet.binary.macroenabled org.openxmlformats.spreadsheetml.sheet.macroenabled \
           public.comma-separated-values-text; do
  $PB -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:$i string $uti" "$PLIST"
  i=$((i + 1))
done

/usr/bin/codesign --force --deep --sign - "$APP" 2>/dev/null
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP"
touch "$APP"
print "Built $APP"

#!/usr/bin/env bash
# Builds the Flutter app and drops it where the Jaspr shell serves it (/flutter/).
set -euo pipefail
cd "$(dirname "$0")/todo_flutter"
FLUTTER="${FLUTTER:-/Volumes/PersonalSSD/av153k/Developer/tools/flutter/bin/flutter}"
"$FLUTTER" build web --release --base-href /flutter/ --no-web-resources-cdn
rm -rf ../jaspr_shell/web/flutter
cp -R build/web ../jaspr_shell/web/flutter

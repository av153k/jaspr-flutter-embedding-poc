# Embedding POC: Jaspr shell + embedded Flutter

One document that never reloads. Jaspr owns the page and the URL; Flutter boots
once, lazily, into `#flutter-host`.

| Path | Rendered by | Routed by |
| --- | --- | --- |
| `/page1` | Jaspr (HTML) | Jaspr router |
| `/page2`, `/page3` | Flutter | Flutter (`go_router`) |

## Run

```sh
./build_flutter.sh                         # Flutter web -> jaspr_shell/web/flutter/
cd jaspr_shell && jaspr serve --port 8090  # dart pub global activate jaspr_cli
```

Open http://localhost:8090/page1. Re-run `build_flutter.sh` after changing Flutter code.

## What to try

1. Page 2 → tap the counter → Page 1 → Page 3: the counter and the
   "Engine booted at" time never reset, because the engine is reused.
2. Inside Flutter, "Go to Page 3" changes the URL without a page load.
3. Flutter's "Go to Page 1 (HTML)" hands control back to Jaspr.
4. Reload on `/page3`: deep links work, Jaspr passes the path to go_router.

## Where things are

- `jaspr_shell/web/bridge.js` — two one-way channels (`toFlutter`, `toPage`); the
  first event emitted to Flutter also loads `flutter/flutter_bootstrap.js` (lazy boot).
- `todo_flutter/web/flutter_bootstrap.js` — custom loader: `hostElement` embedding.
- `jaspr_shell/lib/components/flutter_slot.dart` — the persistent host `<div>`;
  only shown/hidden, never rebuilt. Sends `NAVIGATE`, applies `ROUTE_CHANGED`.
- `todo_flutter/lib/main.dart` — `setUrlStrategy(null)` so Flutter does not touch
  the URL; go_router state is synced over the bridge.

## Why a bridge at all

Embedding only puts Flutter's output inside a `<div>`. Jaspr and Flutter each have
a router, so something must tell each side when the other changed route.

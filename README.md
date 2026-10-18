# Embedding POC: Jaspr shell + embedded Flutter (`jaspr_flutter_embed`)

One document that never reloads. Jaspr owns the page and the URL; Flutter runs
inside the same Dart program via `FlutterEmbedView`, so pages and widgets share
state with plain props and callbacks — no JS bridge.

| Path | Rendered by | Routed by |
| --- | --- | --- |
| `/page1` | Jaspr (HTML) | Jaspr router |
| `/page2`, `/page3` | Flutter | Flutter (`go_router`) |

> The `main` branch has the earlier version with a hand-written JS bridge and a
> separately built Flutter app, for comparison.

## Run

```sh
dart pub global activate jaspr_cli
cd jaspr_shell && jaspr serve --port 8090   # first build takes ~40s
```

Open http://localhost:8090/page1. There is no separate Flutter build step.

## What to try

1. Page 3 → tap the counter → Page 2 (Flutter router) → Page 1 → Page 3: the
   counter and the "created at" time never reset.
2. Flutter's "Go to Page 1 (HTML)" calls back into Jaspr's router.
3. Reload on `/page3`: Jaspr passes the path to go_router.

## Where things are

- `todo_flutter/lib/flutter_pages.dart` — the Flutter pages: `FlutterPages(path,
  onRouteChanged, onOpenHtml)`. `didUpdateWidget` applies a new `path` to go_router.
- `jaspr_shell/lib/components/flutter_slot.dart` — `FlutterEmbedView` placed in the
  shell *outside* the router's child, so it is shown/hidden and never disposed.
- `jaspr_shell/lib/main.client.dart` — `setUrlStrategy(null)` so go_router does
  not rewrite the URL (no `/#/`).
- `pubspec.yaml` — `jaspr: flutter: embedded`, `jaspr_flutter_embed`, and the
  Flutter package as a path dependency.

## Gotchas found

- Give the view **finite** max constraints; infinite ones make `Scaffold` throw
  "infinite size during layout".
- Keep the embed view outside the route `child`, or Jaspr disposes it on navigation.
- Wrap route output in a stable element (`#html-outlet`) to avoid a Jaspr
  "Cannot remove fragment from a different parent" assertion.

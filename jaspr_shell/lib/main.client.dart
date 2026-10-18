/// The entrypoint for the **client** app.
///
/// This file is compiled to javascript and executed on the client when loading the page.
library;

// Client-specific Jaspr import.
import 'package:jaspr/client.dart';
// Imports the [App] component.
import 'app.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  // The page owns the browser URL; go_router must not rewrite it (no /#/ hash).
  setUrlStrategy(null);
  // Attaches the [App] component to the <body> of the page.
  runApp(App());
}

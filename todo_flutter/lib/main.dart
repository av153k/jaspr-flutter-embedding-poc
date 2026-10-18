import 'package:flutter/material.dart';

import 'flutter_pages.dart';

/// Standalone entrypoint for running the Flutter pages on their own.
void main() {
  runApp(FlutterPages(
    path: '/page2',
    onRouteChanged: (_) {},
    onOpenHtml: () {},
  ));
}

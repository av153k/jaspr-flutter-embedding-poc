import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'bridge.dart';

void main() {
  // The page owns the browser URL; go_router only keeps its own state.
  setUrlStrategy(null);
  final bootedAt = DateTime.now();
  debugPrint('[flutter] engine boot at $bootedAt');
  runApp(FlutterPages(bridge: PocBridge.connect(), bootedAt: bootedAt));
}

class FlutterPages extends StatefulWidget {
  const FlutterPages({super.key, required this.bridge, required this.bootedAt});

  final PocBridge? bridge;
  final DateTime bootedAt;

  @override
  State<FlutterPages> createState() => _FlutterPagesState();
}

class _FlutterPagesState extends State<FlutterPages> {
  // Lives as long as the engine: it survives visiting the HTML page and back.
  int _taps = 0;
  late final GoRouter _router;
  StreamSubscription<PocEvent>? _subscription;
  String _reported = '';

  String get _location => _router.routeInformationProvider.value.uri.path;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      initialLocation: '/page2',
      routes: [
        GoRoute(path: '/page2', builder: (_, _) => _screen('PAGE 2', '/page3')),
        GoRoute(path: '/page3', builder: (_, _) => _screen('PAGE 3', '/page2')),
      ],
    );
    // Flutter -> page: tell the page when our router moves, so it can pushState.
    _router.routerDelegate.addListener(_reportLocation);
    // Page -> Flutter: the page asks us to show a path (link click, back button).
    _subscription = widget.bridge?.fromPage.listen((event) {
      if (event.type != 'NAVIGATE') return;
      final path = event.payload['path'] as String?;
      if (path != null && path != _location) _router.go(path);
    });
  }

  void _reportLocation() {
    final path = _location;
    if (path == _reported) return;
    _reported = path;
    widget.bridge?.emit('ROUTE_CHANGED', {'path': path});
  }

  Widget _screen(String title, String otherPath) {
    final time = widget.bootedAt.toIso8601String().substring(11, 19);
    return StatefulBuilder(
      builder: (context, setState) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold)),
              const Text('rendered by Flutter, routed by go_router'),
              const SizedBox(height: 16),
              Text('Engine booted at $time'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => setState(() => _taps++),
                child: Text('Taps: $_taps'),
              ),
              TextButton(
                onPressed: () => _router.go(otherPath),
                child: Text('Go to ${otherPath == '/page3' ? 'Page 3' : 'Page 2'} (Flutter router)'),
              ),
              TextButton(
                // Not ours: ask the page to show its HTML route.
                onPressed: () =>
                    widget.bridge?.emit('ROUTE_CHANGED', {'path': '/page1'}),
                child: const Text('Go to Page 1 (HTML)'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _router.routerDelegate.removeListener(_reportLocation);
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF01589B)),
      routerConfig: _router,
    );
  }
}

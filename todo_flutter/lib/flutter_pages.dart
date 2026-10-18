import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pages 2 and 3, routed by go_router. The host (Jaspr) passes the current
/// [path] in and gets route changes and "leave Flutter" requests as callbacks —
/// plain Dart, no JS interop.
class FlutterPages extends StatefulWidget {
  const FlutterPages({
    super.key,
    required this.path,
    required this.onRouteChanged,
    required this.onOpenHtml,
  });

  final String path;
  final ValueChanged<String> onRouteChanged;
  final VoidCallback onOpenHtml;

  @override
  State<FlutterPages> createState() => _FlutterPagesState();
}

class _FlutterPagesState extends State<FlutterPages> {
  final _bootedAt = DateTime.now();
  // Lives as long as this widget is mounted: it survives the HTML page.
  int _taps = 0;
  late final GoRouter _router;
  String _reported = '';

  String get _location => _router.routeInformationProvider.value.uri.path;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      initialLocation: _isFlutterPath(widget.path) ? widget.path : '/page2',
      routes: [
        GoRoute(path: '/page2', builder: (_, _) => _screen('PAGE 2', '/page3')),
        GoRoute(path: '/page3', builder: (_, _) => _screen('PAGE 3', '/page2')),
      ],
    );
    _router.routerDelegate.addListener(_reportLocation);
  }

  static bool _isFlutterPath(String path) =>
      path == '/page2' || path == '/page3';

  @override
  void didUpdateWidget(FlutterPages oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Page -> Flutter: the page's URL changed (link click, back button).
    if (_isFlutterPath(widget.path) && widget.path != _location) {
      _router.go(widget.path);
    }
  }

  void _reportLocation() {
    final path = _location;
    if (path == _reported) return;
    _reported = path;
    widget.onRouteChanged(path);
  }

  Widget _screen(String title, String otherPath) {
    final time = _bootedAt.toIso8601String().substring(11, 19);
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
              Text('Flutter widget created at $time'),
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
                onPressed: widget.onOpenHtml,
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

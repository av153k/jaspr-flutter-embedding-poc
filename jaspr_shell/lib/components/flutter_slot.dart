import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'poc_bridge.dart';

/// The one element Flutter renders into. It sits outside the router's `child`,
/// so it is never rebuilt on navigation — only shown or hidden.
class FlutterSlot extends StatefulComponent {
  const FlutterSlot({required this.visible, required this.path, super.key});

  final bool visible;
  final String path;

  @override
  State<FlutterSlot> createState() => _FlutterSlotState();
}

class _FlutterSlotState extends State<FlutterSlot> {
  void Function()? _unsubscribe;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    // Flutter changed route itself, so the page pushes the URL.
    _unsubscribe = onFlutterRouteChanged((route) {
      if (mounted) context.push(route);
    });
    _sync();
  }

  @override
  void didUpdateComponent(FlutterSlot oldComponent) {
    super.didUpdateComponent(oldComponent);
    _sync();
  }

  void _sync() {
    if (kIsWeb && component.visible) navigateFlutter(component.path);
  }

  @override
  void dispose() {
    _unsubscribe?.call();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div(
      id: 'flutter-host',
      styles: Styles(
        display: component.visible ? Display.block : Display.none,
        width: 100.percent,
        height: 85.vh,
      ),
      const [],
    );
  }
}

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

JSObject? _channel(String name) {
  final bridge = globalContext['pocBridge'];
  if (!bridge.isA<JSObject>()) return null;
  return (bridge as JSObject)[name] as JSObject?;
}

/// Flutter -> page: calls [listener] when Flutter changed route on its own.
/// Returns the unsubscribe function.
void Function() onFlutterRouteChanged(void Function(String path) listener) {
  final unsubscribe = _channel('toPage')?.callMethod<JSFunction>(
    'on'.toJS,
    ((JSObject event) {
      if ((event['type'] as JSString).toDart != 'ROUTE_CHANGED') return;
      final payload = event['payload'] as JSObject;
      listener((payload['path'] as JSString).toDart);
    }).toJS,
  );
  return () => unsubscribe?.callAsFunction();
}

/// Page -> Flutter. The first emit also boots the engine; later ones reuse it.
void navigateFlutter(String path) {
  _channel('toFlutter')?.callMethod<JSAny?>(
    'emit'.toJS,
    'NAVIGATE'.toJS,
    <String, Object?>{'path': path}.jsify(),
  );
}

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Flutter's end of the page <-> Flutter pipe installed by the Jaspr shell
/// (`jaspr_shell/web/bridge.js`). Events are `{id, type, payload}`.
class PocBridge {
  PocBridge._(this._bridge);

  /// Null-safe: outside the shell (plain `flutter run`) the bridge is absent.
  static PocBridge? connect() {
    final bridge = globalContext['pocBridge'];
    return bridge.isA<JSObject>() ? PocBridge._(bridge as JSObject) : null;
  }

  final JSObject _bridge;

  /// Events the page sent us. The channel holds anything emitted before we
  /// started listening, so the request that booted Flutter is delivered too.
  Stream<PocEvent> get fromPage {
    final controller = StreamController<PocEvent>();
    final toFlutter = _bridge['toFlutter'] as JSObject;
    final unsubscribe = toFlutter.callMethod<JSFunction>(
      'on'.toJS,
      ((JSObject event) {
        controller.add(PocEvent(
          (event['type'] as JSString).toDart,
          (event['payload'].dartify() as Map?)?.cast<String, Object?>() ?? {},
        ));
      }).toJS,
    );
    controller.onCancel = () => unsubscribe.callAsFunction();
    return controller.stream;
  }

  void emit(String type, [Map<String, Object?> payload = const {}]) {
    final toPage = _bridge['toPage'] as JSObject;
    toPage.callMethod<JSAny?>('emit'.toJS, type.toJS, payload.jsify());
  }
}

class PocEvent {
  const PocEvent(this.type, this.payload);
  final String type;
  final Map<String, Object?> payload;
}

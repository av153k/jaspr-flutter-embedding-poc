// JS interop only exists in the browser build; the stub keeps the VM-side
// analysis/build of the same library happy.
export 'poc_bridge_stub.dart' if (dart.library.js_interop) 'poc_bridge_web.dart';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:todo_flutter/flutter_pages.dart';

/// Hosts the Flutter pages. It sits outside the router's `child`, so Jaspr never
/// disposes it on navigation — it is only shown or hidden.
class FlutterSlot extends StatelessComponent {
  const FlutterSlot({required this.visible, required this.path, super.key});

  final bool visible;
  final String path;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        display: visible ? Display.block : Display.none,
        width: 100.percent,
        height: 500.px,
      ),
      [
        FlutterEmbedView(
          constraints: ViewConstraints(
            // Finite on purpose: Scaffold expands to the max, and an infinite
            // max makes Flutter throw "infinite size during layout".
            minWidth: 300,
            minHeight: 500,
            maxWidth: 900,
            maxHeight: 500,
          ),
          widget: FlutterPages(
            path: path,
            // Flutter -> page: plain callbacks into Jaspr's router.
            onRouteChanged: (route) => context.push(route),
            onOpenHtml: () => context.push('/page1'),
          ),
        ),
      ],
    );
  }
}

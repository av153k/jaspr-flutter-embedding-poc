import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class Header extends StatelessComponent {
  const Header({super.key});

  @override
  Component build(BuildContext context) {
    final activePath = RouteState.of(context).location;

    return header([
      nav([
        for (final route in [
          (label: 'Page 1 (HTML)', path: '/page1'),
          (label: 'Page 2 (Flutter)', path: '/page2'),
          (label: 'Page 3 (Flutter)', path: '/page3'),
        ])
          div(classes: activePath == route.path ? 'active' : null, [
            Link(to: route.path, child: .text(route.label)),
          ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('header', [
      css('&').styles(display: .flex, width: 100.percent, padding: .all(1.em), justifyContent: .center),
      css('nav', [
        css('&').styles(
          display: .flex,
          radius: .all(.circular(10.px)),
          overflow: .clip,
          backgroundColor: const Color('#01589B'),
        ),
        css('a').styles(
          display: .block,
          padding: .symmetric(horizontal: 2.em, vertical: 1.em),
          color: Colors.white,
          fontWeight: .w700,
          textDecoration: TextDecoration(line: .none),
        ),
        css('div.active a').styles(backgroundColor: const Color('#0005')),
      ]),
    ]),
  ];
}

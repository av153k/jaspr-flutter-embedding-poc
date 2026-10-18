import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/header.dart';
import 'components/flutter_slot.dart';
import 'pages/page1.dart';

// The main component of your application.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    // This method is rerun every time the component is rebuilt.
    
    // Renders a <div class="main"> html element with children.
    return div(classes: 'main', [
      Router(routes: [
        ShellRoute(
          builder: (context, state, child) => .fragment([
            const Header(),
            // Stable wrapper: Jaspr swaps routes inside it, never at the root.
            div(id: 'html-outlet', [child]),
            // Flutter owns every path except /page1; the slot is only shown/hidden.
            FlutterSlot(
              visible: state.location != '/page1',
              path: state.location,
            ),
          ]),
          routes: [
            Route(path: '/', redirect: (context, state) => '/page1'),
            Route(path: '/page1', title: 'Page 1', builder: (context, state) => const Page1()),
            // Pages 2 and 3 are Flutter's: its own router decides what to show.
            Route(path: '/page2', title: 'Page 2', builder: (context, state) => const div([])),
            Route(path: '/page3', title: 'Page 3', builder: (context, state) => const div([])),
          ],
        ),
      ]),
    ]);
  }

  // Defines the CSS styles for this component.
  //
  // By using the @css annotation, these will be rendered automatically to CSS and included in your page.
  // Must be a variable or getter of type [List<StyleRule>].
  @css
  static List<StyleRule> get styles => [
    css('.main', [
      // The '&' refers to the parent selector of a nested style rules.
      css('&').styles(
        display: .flex,
        height: 100.vh,
        flexDirection: .column,
        flexWrap: .wrap,
      ),
      css('section').styles(
        display: .flex,
        flexDirection: .column,
        justifyContent: .center,
        alignItems: .center,
        flex: Flex(grow: 1),
      ),
    ]),
  ];
}

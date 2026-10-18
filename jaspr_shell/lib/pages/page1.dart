import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Page1 extends StatelessComponent {
  const Page1({super.key});

  @override
  Component build(BuildContext context) {
    return const section([
      h1([.text('PAGE 1')]),
      p([.text('rendered by Jaspr (plain HTML)')]),
    ]);
  }
}

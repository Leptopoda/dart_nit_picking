import 'dart:io';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

final removedRules = [
  'always_specify_types',
  'always_use_package_imports',
  'avoid_annotating_with_dynamic',
  'avoid_as',
  'avoid_catches_without_on_clauses',
  'avoid_catching_errors',
  'avoid_classes_with_only_static_members',
  'avoid_positional_boolean_parameters',
  'avoid_print',
  'diagnostic_describe_all_properties',
  'empty_catches',
  'lines_longer_than_80_chars',
  'no_default_cases',
  'omit_local_variable_types',
  'one_member_abstracts',
  'parameter_assignments',
  'prefer_double_quotes',
  'prefer_relative_imports',
  'unnecessary_final',
  'unnecessary_null_checks',
];

Future main() async {
  final body = (await http.get(
    Uri.parse(
      'https://raw.githubusercontent.com/dart-lang/linter/gh-pages/lints/options/options.html',
    ),
  ))
      .body;
  final document = parse(body);

  var config = '''
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: true
  errors:
    flutter_style_todos: ignore
    todo: ignore
  exclude:
    - "lib/generated_plugin_registrant.dart"
    - "lib/l10n/**"
    - "**.g.dart"
    - "**.mocks.dart"
linter:
  rules:
''';

  config += document
      .getElementsByTagName('code')[0]
      .text
      .split('\n')
      .where((final line) => line.startsWith('    - '))
      .map((final line) => line.replaceAll('    - ', ''))
      .map(
        (final line) =>
            '    $line: ${removedRules.contains(line) ? 'false' : 'true'}',
      )
      .join('\n');
  File('lib/dart.yaml').writeAsStringSync(config);
}

library transformer_test;

import 'package:test/test.dart';
import 'package:ex_map/ex_map.dart';
import 'package:ex_map/transformer.dart';

String source = """
library some_library;

import 'package:ex_map/ex_map.dart';

@ExMap
class TestMap extends ExtendedMap {
  @MapKey()
  int id;

  @MapKey(protected: true, type: int)
  String integerField;

  @MapKey()
  String testField;
}
""";

void main() {
  test('ExMap transform must work right', () {
    String outputString = parse(source);

    print(outputString);

    expect(outputString, isNotNull);
    expect(outputString, isNotEmpty);
  });
}

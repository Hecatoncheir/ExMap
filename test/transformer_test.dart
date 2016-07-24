library transformer_test;

import 'package:ex_map/transformer.dart';
import 'package:transformer_test/utils.dart';

String _source = """
library ex_map_test;

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

String _expectedSource = """
library ex_map_test;

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
  testPhases('ExMap transformer must work', [
    [new TransformObjectToMap()]
  ], {
    'a|test/ex_map_test.dart': _source
  }, {
    'a|test/ex_map_test.dart': 'source',
  });
}

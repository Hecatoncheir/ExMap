library transformer_test;

import 'package:ex_map/transformer.dart';
import 'package:transformer_test/utils.dart';

String _entrySource = """
library ex_map_test;

import 'package:ex_map/ex_map.dart';

@ExMap
class TestMap extends ExtendedMap {
  @ExKey()
  int id;

  @ExKey(protected: true, type: int)
  int integerField;

  @ExKey(type: String)
  var testField;

  var notAnnotatedProperty;
}

class NotAnnotatedClass {}
""";

String _expectedSource = """
library ex_map_test;

import 'package:ex_map/ex_map.dart';

@ExMap
class TestMap extends ExtendedMap {
  get propertyName => this[propertyName];
  set propertyName(value) => this[propertyName] = value;

  get propertyName => this[propertyName];
  set propertyName(value) => this[propertyName] = value;

  get propertyName => this[propertyName];
  set propertyName(value) => this[propertyName] = value;
  
  var notAnnotatedProperty;
}

class NotAnnotatedClass {}
""";

void main() {
  testPhases('ExMap transformer must work', [
    [new TransformObjectToMap()]
  ], {
    'a|test/ex_map_test.dart': _entrySource
  }, {
    'a|test/ex_map_test.dart': _expectedSource,
  });
}

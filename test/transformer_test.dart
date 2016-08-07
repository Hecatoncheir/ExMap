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
  String integerField;

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
  List protectedKeys = [integerField];
  Map types = {id: dynamic, integerField: int, testField: String};

  get id => this['id'];
  set id(value) => this['id'] = value;

  get integerField => this['integerField'];
  set integerField(value) => this['integerField'] = value;

  get testField => this['testField'];
  set testField(value) => this['testField'] = value;
  
  var notAnnotatedProperty;
}

class NotAnnotatedClass {}
""";

//Map types = {'id':int, 'integerField': String, 'testField': String};

void main() {
  testPhases('ExMap transformer must work', [
    [new TransformObjectToMap()]
  ], {
    'a|test/ex_map_test.dart': _entrySource
  }, {
    'a|test/ex_map_test.dart': _expectedSource,
  });
}

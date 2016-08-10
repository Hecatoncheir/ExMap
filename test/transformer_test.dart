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

@ExMap
class TestMapAgane extends ExtendedMap {
  @ExKey()
  int id;

  var notAnnotatedProperty;
}

class NotAnnotatedClass {}
""";

String _expectedSource = """
library ex_map_test;

import 'package:ex_map/ex_map.dart';

@ExMap
class TestMap extends ExtendedMap {

  TestMap() {
    protectedKeys = ['integerField'];
    types = {'id': int, 'integerField': int, 'testField': String};
  }

  get id => this['id'];
  set id(value) => this['id'] = value;

  get integerField => this['integerField'];
  set integerField(value) => this['integerField'] = value;

  get testField => this['testField'];
  set testField(value) => this['testField'] = value;
  
  var notAnnotatedProperty;
}

@ExMap
class TestMapAgane extends ExtendedMap {

  TestMapAgane() {
    protectedKeys = [];
    types = {'id': int};
  }

  get id => this['id'];
  set id(value) => this['id'] = value;

  var notAnnotatedProperty;
}

class NotAnnotatedClass {}
""";

String _mapAnnotationTest = """
library map_annotation_test;

import 'package:test/test.dart';
import 'package:ex_map/ex_map.dart';

@ExMap
class TestMap extends ExtendedMap {
  @ExKey()
  int id;

  @ExKey(protected: true, type: int)
  int integerField;

  @ExKey(type: String)
  var testField;
}

void main() {
  TestMap map;

  setUp(() {
    map = new TestMap();
  });

  group('The TestMap class', () {
    test('has protected fields', () {
      map.id = 1;
      expect(map['id'], equals(1));
    });

    test('has right types', () {
      map.integerField = 1;
      expect(map['integerField'], equals(1));

      map['testField'] = 2;
      expect(map.testField, equals('2'));
    });
  });
}

""";

String _expectedMapAnnotationTest = """
library map_annotation_test;

import 'package:test/test.dart';
import 'package:ex_map/ex_map.dart';

@ExMap
class TestMap extends ExtendedMap {

  TestMap() {
    protectedKeys = ['integerField'];
    types = {'id': int, 'integerField': int, 'testField': String};
  }

  get id => this['id'];
  set id(value) => this['id'] = value;

  get integerField => this['integerField'];
  set integerField(value) => this['integerField'] = value;

  get testField => this['testField'];
  set testField(value) => this['testField'] = value;
}

void main() {
  TestMap map;

  setUp(() {
    map = new TestMap();
  });

  group('The TestMap class', () {
    test('has protected fields', () {
      map.id = 1;
      expect(map['id'], equals(1));
    });

    test('has right types', () {
      map.integerField = 1;
      expect(map['integerField'], equals(1));

      map['testField'] = 2;
      expect(map.testField, equals('2'));
    });
  });
}

""";

void main() {
  testPhases('ExMap transformer must work', [
    [new TransformObjectToMap()]
  ], {
    'a|test/ex_map_test.dart': _entrySource
  }, {
    'a|test/ex_map_test.dart': _expectedSource,
  });

  testPhases('Annoteted class must be transformed', [
    [new TransformObjectToMap()]
  ], {
    'a|test/map_annotation_test.dart': _mapAnnotationTest
  }, {
    'a|test/map_annotation_test.dart': _expectedMapAnnotationTest,
  });
}

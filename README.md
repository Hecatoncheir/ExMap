
[![c9](http://wiki.teamliquid.net/commons/images/thumb/f/fd/Cloud9.png/48px-Cloud9.png) - editor](https://ide.c9.io/rasart/ex_map)

[![Build Status](https://codeship.com/projects/bbc87340-415a-0134-5cdb-527eefe58aba/status?branch=master)](https://codeship.com/projects/bbc87340-415a-0134-5cdb-527eefe58aba/status?branch=master) 
[![pub package](https://img.shields.io/pub/v/ex_map.svg?style=flat)](https://pub.dartlang.org/packages/ex_map)


A library for writing pretty simple object class with Map interface.

Use transformer:
```yaml
transformers:
  - ex_map
```

And that:
```dart
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
```

will be transformed to:
```dart
library ex_map_test;
import 'package:ex_map/ex_map.dart';

@ExMap
class TestMap extends ExtendedMap {
  TestMap({int id, int integerField, String testField}) {
    protectedKeys.addAll(['integerField']);
    types = {'id': int, 'integerField': int, 'testField': String};
  }
  
  get id => this['id'];
  set id(value) => this['id'] = value;
  
  get integerField => this['integerField'];
  set integerField(value) => setProtectedField('integerField', value);
  
  get testField => this['testField'];
  set testField(value) => this['testField'] = value;
  
  var notAnnotatedProperty;
}
```

**protectedKeys** - can not be set differently than through special method. (setProtectedField)
That property can be established only through the operator: "."

**types** - need to check type of value before save:
```dart
class FieldsTestMap extends ExtendedMap {
  FieldsTestMap({id, integerField, testField}) {
    types = {
      'stringField': String,
      'intField': int,
      'doubleField': double,
      'dateField': DateTime,
      'boolField': bool
    };
  }
  
  /// Test
  group('The extended map', () {
    test('has right types', () {
      FieldsTestMap map = new FieldsTestMap();

      map['stringField'] = 1;
      expect(map.stringField, equals('1'));

      map['stringField'] = '2';
      expect(map.stringField, equals('2'));

      map['intField'] = '1';
      expect(map.intField, equals(1));

      map['intField'] = 2;
      expect(map.intField, equals(2));

      map['doubleField'] = '2.2';
      expect(map.doubleField, equals(2.2));

      map['doubleField'] = 2.1;
      expect(map.doubleField, equals(2.1));

      DateTime date = new DateTime.now();
      map['dateField'] = date.toString();
      expect(map.dateField, equals(date));

      map['dateField'] = date;
      expect(map.dateField, equals(date));

      map['boolField'] = 'true';
      expect(map.boolField, equals(true));

      map['boolField'] = false;
      expect(map.boolField, equals(false));
    });
  });
```

##### TODO:
  - Default constructor check in transformer
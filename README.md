[![Build Status](https://codeship.com/projects/bbc87340-415a-0134-5cdb-527eefe58aba/status?branch=master
)](https://codeship.com/projects/bbc87340-415a-0134-5cdb-527eefe58aba/status?branch=master
)

With the object easier to work when he has a good Map api. Such an object is serialized and deserialized well.
The class constructor can be designated  properties of map and types, and properties be designed with get and set:

```dart
class TestMap extends ExtendedMap {
  TestMap({id, integerField, testField}) {
    /// The property can not be set differently than through special method
    protectedKeys.add('id');
    types = {'testField': String, 'integerField': int};
  }

  /// The property can be established only through the operator: "."
  get id => this['id'];
  set id(value) => setProtectedField('id', value);

  get integerField => this['integerField'];
  set integerField(value) => this['integerField'] = value;

  get testField => this['testField'];
  set testField(value) => this['testField'] = value;
}

```

```dart
TestMap map;

setUp(() {
  map = new TestMap();
});

test('has protected fields', () {
  map.id = 1;
  expect(map['id'], equals(1));
  try {
    map['id'] = 2;
  } catch (error) {
    expect((error as ArgumentError).message, equals("id can't be changed"));
  }
});

test('has right types', () {
  map.integerField = 1;
  expect(map['integerField'], equals(1));

  map['testField'] = 2;
  expect(map.testField, equals('2'));
});

test('has a map interface', () {
  map.testField = 'test';

  expect(map.testField, equals('test'));
  expect(map['testField'], equals('test'));
});
```

### Annotation for transformer:

``` dart
/// original source    =>   be transformed to   =>   ready for use 
import 'package:ex_map/ex_map.dart';      ///    import 'package:ex_map/ex_map.dart';
                                          ///
@ExMap                                    ///    @ExMap
class ExampleMap extends ExtendedMap {    ///    class ExampleMap extends ExtendedMap {
  @ExKey()                                ///
  int id;                                 ///       ExampleMap({int id, int integerField, String testField}) {
                                          ///         protectedKeys.addAll(['integerField']);
  @ExKey(protected: true, type: int)      ///         types = {'id': int, 'integerField': int, 'testField': String};
  int integerField = 1;                   ///         this.integerField = 1;
                                          ///         this['testField'] = 'test';
  @ExKey(type: String)                    ///       }
  var testField = 'test';                 ///       
}                                         ///       get id => this['id'];
                                          ///       set id(value) => this['id'] = value;
                                          ///
                                          ///       get integerField => this['integerField'];
                                          ///       set integerFieldd(value) => setProtectedField('integerField', value);
                                          ///
                                          ///       get testField => this['testField'];
                                          ///       set testField(value) => this['testField'] = value;
                                          ///    }
```

TODO:
  - Default constructor check in transformer
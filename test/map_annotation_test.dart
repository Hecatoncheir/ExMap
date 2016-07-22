library map_annotation_test;

import 'package:test/test.dart';
import 'package:ex_map/ex_map.dart';

@exMap
class TestMap extends ExMap {
  @MapKey()
  get id => this['id'];
  set id(value) => setProtectedField('id', value);

  @MapKey(protected: true)
  get integerField => this['integerField'];
  set integerField(value) => this['integerField'] = value;

  @MapKey()
  get testField => this['testField'];
  set testField(value) => this['testField'] = value;
}

void main() {
  TestMap map;
  prepareExMaps();

  setUp(() {
    map = new TestMap();
  });

  group('The TestMap class', () {
    test('has protected fields', () {
      map.id = 1;
      expect(map['id'], equals(1));

      map.integerField = '1';
      expect(map['integerField'], equals(1));

      map['testField'] = 2;
      expect(map.testField, equals('2'));
    });
  });
}

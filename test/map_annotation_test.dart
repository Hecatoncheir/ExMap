@Skip()
library map_annotation_test;

import 'package:test/test.dart';
import 'package:ex_map/ex_map.dart';

@ExMap
class TestMap extends ExtendedMap {
  @MapKey()
  int id;

  @MapKey(protected: true, type: int)
  int integerField;

  @MapKey()
  String testField;
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

      map.integerField = '1';
      expect(map['integerField'], equals(1));

      map['testField'] = 2;
      expect(map.testField, equals('2'));
    });
  });
}

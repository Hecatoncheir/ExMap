library map_annotation_test;

import 'package:test/test.dart';
import 'package:map_annotation/map_annotation.dart';

@ExMap()
class TestMap extends ExtendedMap {
  @MapKey()
  String testField;

  @MapKey(protected: true)
  String protectedField;
}

void main() {
  TestMap map;
  prepareExtendedMaps();

  setUp(() {
    map = new TestMap();
  });

  group('The extended TestMap class', () {
    test('has a map interface', () {
      map.keys.add('testKey');
      map['testKey'] = 'testValue';
      map.testField = 'test';

      expect(map['testKey'], equals('testValue'));
      expect(map.keys.contains('testKey'), isTrue);

      expect(map.testField, equals('test'));
      expect(map['testField'], equals('test'));
    });
  });
}

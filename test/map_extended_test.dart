library map_extended_test;

import 'dart:convert';

import 'package:test/test.dart';
import 'package:ex_map/ex_map.dart';

class TestMap extends ExtendedMap {
  TestMap({id, integerField, testField}) {
    protectedKeys.add('id');
    types = {'testField': String, 'integerField': int};
  }

  get id => this['id'];
  set id(value) => setProtectedField('id', value); // Can't set with []. Only like .id

  get integerField => this['integerField'];
  set integerField(value) => this['integerField'] = value;

  get testField => this['testField'];
  set testField(value) => this['testField'] = value;
}

main() {
  TestMap map;

  setUp(() {
    map = new TestMap();
  });

  group('The extended TestMap class', () {
    test('has protected fields', () {
      map.id = 1;
      expect(map['id'], equals(1));

      map.integerField = '1';
      expect(map['integerField'], equals(1));

      map['testField'] = 2;
      expect(map.testField, equals('2'));
    });

    test('has a map interface', () {
      map.testField = 'test';

      expect(map.testField, equals('test'));
      expect(map['testField'], equals('test'));
    });

    test("can't set values without keys", () {
      map.keys.add('testKey');
      map['testKey'] = 'testValue';
      expect(map['testKey'], equals('testValue'));
    });

    test('can be encodable to JSON', () {
      map.testField = 'test';

      map.keys.add('testKey');
      map['testKey'] = 'testValue';

      String jmap = JSON.encode(map);
      expect(
          jmap,
          equals(
              '{"testField":"test","integerField":null,"testKey":"testValue"}'));

      Map decodedMap = JSON.decode(jmap);
      expect(
          decodedMap,
          equals({
            'testField': 'test',
            'integerField': null,
            'testKey': 'testValue'
          }));
    });

    test('has right keys like class fields', () {
      expect(map.keys.contains('testField'), isTrue);
    });

    test('can be build from Map', () {
      map.testField = 'testField';

      TestMap fromMap = new TestMap().fromMap(map);
      expect(fromMap, equals(map));
    });
  });
}

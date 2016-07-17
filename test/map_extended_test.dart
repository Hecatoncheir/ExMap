library map_extended_test;

import 'dart:convert';

import 'package:test/test.dart';
import 'package:map_annotation/map_extended.dart';

class TestMap extends ExtendedMap {

  TestMap(){
    keys.addAll(['testField']);
  }

  get testField => this['testField'];
  set testField(value) {
    this['testField'] = value;
  }
}

main() {
  TestMap map;

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

    test("can't set values without keys", (){
      map['testKey'] = 'testValue';
      expect(map['testKey'], isNull);

      map.keys.add('testKey');
      map['testKey'] = 'testValue';
      expect(map['testKey'], equals('testValue'));
    });

    test('can be encodable to JSON', () {
      map.testField = 'test';

      map.keys.add('testKey');
      map['testKey'] = 'testValue';

      String jmap = JSON.encode(map);
      expect(jmap, equals('{"testField":"test","testKey":"testValue"}'));

      Map decodedMap = JSON.decode(jmap);
      expect(decodedMap, equals({'testField': 'test', 'testKey': 'testValue'}));
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

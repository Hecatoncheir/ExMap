library map_extended_test;

import 'dart:convert';

import 'package:test/test.dart';
import 'package:ex_map/ex_map.dart';

class TestMap extends ExtendedMap {
  TestMap({id, integerField, testField}) {
    protectedKeys.addAll(['id']);
    types = {'testField': String, 'integerField': int};
    this.withoutCheckTypes = false;
  }

  get id => this['id'];
  set id(value) =>
      setProtectedField('id', value); // Can't set with []. Only like a property

  get integerField => this['integerField'];
  set integerField(value) => this['integerField'] = value;

  get testField => this['testField'];
  set testField(value) => this['testField'] = value;
}

class FieldsTestMap extends ExtendedMap {
  FieldsTestMap({id, integerField, testField}) {
    types = {
      'stringField': String,
      'intField': int,
      'doubleField': double,
      'dateField': DateTime,
      'boolField': bool,
      'testMapField': TestMap
    };

    this.withoutCheckTypes = false;
  }

  get stringField => this['stringField'];
  set stringField(value) => this['stringField'] = value;

  get intField => this['intField'];
  set intField(value) => this['intField'] = value;

  get doubleField => this['doubleField'];
  set doubleField(value) => this['doubleField'] = value;

  get dateField => this['dateField'];
  set dateField(value) => this['dateField'] = value;

  get boolField => this['boolField'];
  set boolField(value) => this['boolField'] = value;

  get testMapField => this['testMapField'];
  set testMapField(value) => this['testMapField'] = value;
}

main() {
  TestMap map;

  setUp(() {
    map = new TestMap();
  });

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

  group('The extended TestMap class', () {
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

Иногда нужно иметь возможность работать со свойствами объекта так же удобно как с ключами Map'a. С самим объектом удобнее работать когда у него есть хорошие api Map'a. Такой объект хорошо сериализуется и десериализуется.

В конструкторе классa можно обозначить Map из свойств и типов, а самим свойствам назначать get и set:

```dart
class TestMap extends ExtendedMap {
  TestMap({id, integerField, testField}) {
    /// Свойство нельзя будет установить иначе кроме как через специальный метод
    protectedKeys.add('id');
    types = {'testField': String, 'integerField': int};
  }

  /// Свойство можно будет установить только через оператор "."
  get id => this['id'];
  set id(value) => setProtectedField('id', value);

  /// Тут можно было бы обозначить типы
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

### Аннотации

 Возможно библиотеку **dart:mirrors** уберут из sdk, но сейчас этим можно пользоваться, да и как отдельный пакет mirror, скорее всего, останутся.

  Сократить объем работы с помощью аннотаций можно следующим образом:
``` dart
import 'package:ex_map/ex_map.dart';

@ExAMap()
class TestMap extends ExMap {

  @MapKey()
  int id;

  @MapKey(protected: true, type: int)
  int integerField;

  @MapKey(type: String)
  String testField;
}

```

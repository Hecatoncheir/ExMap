Иногда нужно иметь возможность работать со свойствами объекта так же удобно как с ключами Map'a. С самим объектом удобнее работать когда у него есть хорошие api Map'a. Такой объект хорошо сериализуется и десериализуется.

Можно обозначать в конструкторе класса Map из свойств и типов, а самим свойствам назначать get и set:

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

### Аннотации
  
 Все это хорошо, но мне нравится больше использовать аннотации. Возможно библиотеку **dart:mirrors** уберут из sdk, но сейчас этим можно пользоваться, да и как отдельный пакет mirrors останутся.
  
  Сократить объем работы с помощью аннотаций можно следующим образом:
``` dart 
import 'package:ex_map/ex_map.dart';

@ExAMap()
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

```

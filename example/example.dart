library example;

import 'dart:html';
import 'package:ex_map/ex_map.dart';

@ExMap
class ExampleMap extends ExtendedMap {
  @ExKey()
  int id;

  @ExKey(protected: true, type: int)
  int integerField;

  @ExKey(type: String)
  var testField;
}

main() {
  ExampleMap exampleMap = new ExampleMap();
  exampleMap['id'] = 1;
  querySelector('body')
    ..appendText('keys: ${exampleMap.keys.toString()}')
    ..append(new Element.br())
    ..appendText('id: ${exampleMap.id}');
}

library map_extended;

import 'dart:collection';
export 'dart:collection';

part 'ex_map_annotation.dart';

class ExtendedMap<K, V> extends Object with MapMixin {
  Map _Map = new Map();
  Set _keys = new Set();
  Map _types = new Map();

  Set get keys => _keys;

  Map<String, Type> get types => _types;
  set types(Map typeMap) {
    _types = typeMap;
    _keys = typeMap.keys.toSet();
  }

  Set protectedKeys = new Set();

  Map fromMap(Map map) {
    this.keys.forEach((String extendedKey) {
      _Map[extendedKey] = map[extendedKey];
    });

    return this;
  }

  setProtectedField(K key, V value) {
    keys.add(key);
    protectedKeys.remove(key);
    _Map[key] = value;
    protectedKeys.add(key);
  }

  operator [](Object key) {
    return _Map[key];
  }

  operator []=(K key, V value) {
    if (protectedKeys.contains(key) || !keys.contains(key)) {
      throw new ArgumentError("$key can't be changed");
    }

    _Map[key] = value;

    /// Todo: camelCaseTSnakeCase or snakeCaseToCamel

    if (types[key] == String) {
      _Map[key] = value.toString();
      return;
    }

    if (types[key] == int) {
      _Map[key] = int.parse(value.toString());
      return;
    }
  }

  remove(key) {
    _Map.remove(key);
  }

  clear() {
    _Map.clear();
  }
}

library extended_map;

import 'dart:collection';
export 'dart:collection';

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

  /// Todo: camelCaseTSnakeCase or snakeCaseToCamel
  dynamic _checkType({String key, dynamic value, Map types}) {
    if (types[key] == String) {
      return value.toString();
    }

    if (types[key] == int && value != null) {
      return int.parse(value.toString());
    }

    return value;
  }

  Map fromMap(Map map) {
    this.keys.forEach((String extendedKey) {
      _Map[extendedKey] =
          _checkType(key: extendedKey, value: map[extendedKey], types: types);
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

    _Map[key] = _checkType(key: key.toString(), value: value, types: types);
  }

  remove(key) {
    _Map.remove(key);
  }

  clear() {
    _Map.clear();
  }
}

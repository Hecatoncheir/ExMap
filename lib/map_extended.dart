library map_extended;

import 'dart:collection';
export 'dart:collection';

class ExtendedMap<K, V> extends Object with MapMixin {
  Map _Map = new Map();
  List _keys = new List();
  List _protectedFields = new List();

  Map fromMap(Map map) {
    this.keys.forEach((String extendedKey) {
      _Map[extendedKey] = map[extendedKey];
    });

    return this;
  }

  operator [](Object key) {
    return _Map[key];
  }

  operator []=(K key, V value) {
    if (!_keys.contains(key)) return;
    if (_protectedFields.contains(key)) return;
    _Map[key] = value;
  }

  get keys => _keys;

  remove(key) {
    _keys.remove(key);
    _Map.remove(key);
  }

  clear() {
    _keys.clear();
    _Map.clear();
  }
}

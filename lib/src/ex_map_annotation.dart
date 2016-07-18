part of map_extended;

class ExMap<K, V> extends Object with MapMixin {
  Map _Map = new Map();
  static Set set;

  Set get keys => set;

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
    if (protectedKeys.contains(key)) {
      throw new ArgumentError("$key can't be changed");
    }
    _Map[key] = value;
  }

  remove(key) {
    _Map.remove(key);
  }

  clear() {
    _Map.clear();
  }
}
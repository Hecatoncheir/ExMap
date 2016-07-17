library map_annotation;

@MirrorsUsed(symbols: 'ExMap')
import 'dart:mirrors';

import 'package:map_annotation/map_extended.dart';
export 'package:map_annotation/map_extended.dart';

class ExMap {
  const ExMap();
}

class MapKey {
  const MapKey({bool protected});
}

void prepareExtendedMaps() {
  MirrorSystem mirrorSystem = currentMirrorSystem();
  mirrorSystem.libraries.forEach((Uri uri, LibraryMirror libMir) {
    libMir.declarations.forEach((Symbol symbol, DeclarationMirror decMir) {
      decMir.metadata.forEach((InstanceMirror insMir) {
        if (insMir.reflectee is ExMap) {
          print(symbol);
          print(insMir);
        }
      });
    });
  });
}

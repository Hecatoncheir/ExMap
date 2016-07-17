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


  /// Сперва отыскиваются аннотации подходящие по типу ExMap, затем
  /// в библиотеке где аннотации были обнаружены ищутся
  /// аннотированные классы или методы. (Символы аннотированных методов или классов
  /// можно найти при поиске подходящих по типу аннотаций ExMap)
  mirrorSystem.libraries.forEach((Uri uri, LibraryMirror libMir) {
    /// Сперва анализируются все описанные классы и методы библиотек
    libMir.declarations
        .forEach((Symbol annotatedSymbol, DeclarationMirror decMir) {
      /// Для всех найденных аннотаций нужно проверить нужный тип аннотации
      decMir.metadata.forEach((InstanceMirror insMir) {
        /// Если нужный тип аннотаций совпадает, значит в этой библиотеке есть
        /// классы помеченные этой аннотацией.
        if (insMir.reflectee is ExMap) {
          /// Можно получить значения из самой аннотации
          /// insMir.reflectee
          /// либо в библиотеке где были найдены совпадения найти аннотируемые классы
          libMir.declarations.forEach(
              (Symbol symbolInLibraryWhereAnnotationFound,
                  DeclarationMirror methodOrClass) {
                /// Если аннотированный символ метода или класса совпадаются с символами
                /// метода или класса библиотеки то это та запись что нужно было найти.
                if (annotatedSymbol == symbolInLibraryWhereAnnotationFound) {
                  ClassMirror classMirror = methodOrClass;
                  print(classMirror.reflectedType);
                }
              });
        }
      });
    });
  });
}

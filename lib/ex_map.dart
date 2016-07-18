library ex_map;

@MirrorsUsed(symbols: 'ExMap')
import 'dart:mirrors';

import 'src/map_extended.dart';
export 'src/map_extended.dart';

class ExAMap {
  const ExAMap();
}

class MapKey {
  const MapKey({bool protected});
}

void prepareExMaps() {
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
        if (insMir.reflectee is ExAMap) {
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

              Set set = new Set();

              /// Теперь можно находить поля помеченные аннотациями
              classMirror.declarations.forEach((Symbol classMethodOrFieldSymbol,
                  DeclarationMirror classMethodOrField) {
                classMethodOrField.metadata
                    .forEach((InstanceMirror fieldAnnotationMirror) {
                  /// Проверив тип аннотации можно быть уверенным что поле с которым
                  /// можно работать точно соответсвует реально помеченному.
                  if (fieldAnnotationMirror.reflectee is MapKey) {
                    /// Проверка типа
                    /// if((classMethodOrField as VariableMirror).isStatic) {
                    ///   var valueOfField = classMirror.getField(classMethodOrFieldSymbol).reflectee;
                    /// }

                    set.add(MirrorSystem.getName(classMethodOrFieldSymbol));
                  }
                  classMirror.superclass.setField(new Symbol('set'), set);
                });
              });
            }
          });
        }
      });
    });
  });
}

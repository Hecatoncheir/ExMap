library ex_map_transformer;

import 'package:analyzer/analyzer.dart';
import 'package:barback/barback.dart';

class TransformExMap extends Transformer {
  TransformExMap();

  /// https://www.debuggex.com/r/MOY4Zw0u3UVnJIDN
  RegExp keyAnnotatedClassMemberDeclarationPattern = new RegExp(
      r"@ExKey[( ]*(type|protected)?[ :]*(int|String|true)?[, ]*(type|protected)?[ :]*(int|String|true)?[ )]* (int|String|var) ([a-zA-Z]*) ?[ =]? ?([a-zA-Z0-9']*)",
      multiLine: true,
      caseSensitive: false);

  TransformExMap.asPlugin();

  String get allowedExtensions => '.dart';

  @override
  apply(Transform transform) async {
    AssetId id = transform.primaryInput.id;
    String assetSource = await transform.readInputAsString(id);
    Asset asset = new Asset.fromString(id, _transform(source: assetSource));
    transform.addOutput(asset);
  }

  Map<String, int> maxAnnotatedPropertiesPerAnnotetedClass = new Map();

  String _transform({String source}) {
    CompilationUnit unit = parseCompilationUnit(source);
    String updatedSource = source;

    /// Member must be a class and has annotation ExMap
    bool _classMustBeAnnotated(CompilationUnitMember unit) {
      Iterable unitMetaData =
          unit.metadata.map((annotation) => annotation.toString());

      if (unit is ClassDeclaration && unitMetaData.contains('@ExMap'))
        return true;
      return false;
    }

    /// Only annotated classes
    Iterable annotatedClasses = unit.declarations.where(_classMustBeAnnotated);

    for (ClassDeclaration classDeclaration in annotatedClasses) {
      List<String> protectedKeys = new List();
      Map<String, String> types = new Map();
      Map keyAndValue = new Map();

      /// Property must be annotated as ExKey
      bool _classPropertyMustBeAnnotated(ClassMember classProperty) {
        RegExp exKey = new RegExp('@ExKey');

        Iterable unitMetaData = classProperty.metadata.map((annotation) {
          String annotationName = annotation.toString();
          if (exKey.hasMatch(annotationName)) return true;
          return false;
        });

        if (unitMetaData.isNotEmpty) return true;
        return false;
      }

      /// Only annotated members of annotated class
      Iterable annotatedProperties =
          classDeclaration.members.where(_classPropertyMustBeAnnotated);

      if (!maxAnnotatedPropertiesPerAnnotetedClass
          .containsKey(classDeclaration.name.toString())) {
        maxAnnotatedPropertiesPerAnnotetedClass[
            classDeclaration.name.toString()] = annotatedProperties.length;
      }

      annotatedProperties.forEach((ClassMember property) {
        String typeFieldValue = 'dynamic'; // From ExKey annotation
        String propertyName;

        Iterable<Match> matches = keyAnnotatedClassMemberDeclarationPattern
            .allMatches(property.toString());

        for (Match allGroups in matches) {
          if (allGroups[6] != null) {
            propertyName = allGroups[6];
          }

          /// For first ExKey property
          if (allGroups[1] != null) {
            if (allGroups[1] == 'protected') {
              if (allGroups[2] == 'true') {
                protectedKeys.add(propertyName);
              }
            }
            if (allGroups[1] == 'type') {
              typeFieldValue = allGroups[2];
            }
          }

          /// For second ExKey property
          if (allGroups[3] != null) {
            if (allGroups[3] == 'protected') {
              if (allGroups[4] == 'true') {
                protectedKeys.add(propertyName);
              }
            }
            if (allGroups[3] == 'type') {
              typeFieldValue = allGroups[4];
            }
          }

          if (allGroups[5] != null) {
            if (typeFieldValue == 'dynamic') {
              typeFieldValue = allGroups[5];
            }
            types[propertyName] = typeFieldValue;
          }

          if (allGroups[7] != null && allGroups[7].isNotEmpty) {
            keyAndValue[propertyName] = allGroups[7];
          }
        }

        /// Field declaration
        String beforeField = source.substring(0, property.beginToken.offset);
        String afterField = source.substring(property.endToken.offset);

        String getterSource = "get $propertyName => this['$propertyName'];";
        String setterSource;
        if (protectedKeys.contains(propertyName)) {
          setterSource =
              "  set $propertyName(value) => setProtectedField('$propertyName', value)";
        } else {
          setterSource =
              "  set $propertyName(value) => this['$propertyName'] = value";
        }

        String transformedSource =
            beforeField + getterSource + '\n' + setterSource + afterField;

        /// Class declaration
        if (annotatedProperties.length ==
            maxAnnotatedPropertiesPerAnnotetedClass[
                classDeclaration.name.toString()]) {
          String beforeClassDeclaration = transformedSource.substring(
              0, classDeclaration.leftBracket.offset + 1);
          String afterclassDeclaration = transformedSource
              .substring(classDeclaration.leftBracket.offset + 1);

          StringBuffer stringBuffer = new StringBuffer();
          stringBuffer
            ..write(beforeClassDeclaration)
            ..write('\n\n')
            ..write('  ${classDeclaration.name.toString()}() {')
            ..write('\n')
            ..write('    protectedKeys.addAll([');

          for (String pk in protectedKeys) {
            int index = protectedKeys.indexOf(pk);
            if (index == protectedKeys.length - 1) {
              stringBuffer.write("'$pk'");
            } else {
              stringBuffer.write("'$pk', ");
            }
          }

          stringBuffer..write(']);')..write('\n')..write('    types = {');

          for (String field in types.keys) {
            if (field == types.keys.last) {
              stringBuffer.write("'$field': ${types[field]}");
            } else {
              stringBuffer.write("'$field': ${types[field]}, ");
            }
          }

          stringBuffer..write('};')..write('\n');

          if (keyAndValue.isNotEmpty) {
            for (String field in keyAndValue.keys) {
              if (!protectedKeys.contains(field)) {
                stringBuffer
                  ..write("    this['$field'] = ${keyAndValue[field]};")
                  ..write('\n');
              }

              if (protectedKeys.contains(field)) {
                stringBuffer
                  ..write("    this.$field = ${keyAndValue[field]};")
                  ..write('\n');
              }
            }
          }

          stringBuffer..write('  }')..write('\n')..write(afterclassDeclaration);

          transformedSource = stringBuffer.toString();
        }
        updatedSource = _transform(source: transformedSource);
      });
    }

    return updatedSource;
  }
}

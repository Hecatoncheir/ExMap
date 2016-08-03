library ex_map_transformer;

import 'package:analyzer/analyzer.dart';
import 'package:barback/barback.dart';

import 'package:ex_map/ex_map.dart';

class TransformObjectToMap extends Transformer {
  TransformObjectToMap();

  TransformObjectToMap.asPlugin();

  String get allowedExtensions => '.dart';

  @override
  apply(Transform transform) async {
    AssetId id = transform.primaryInput.id;
    String assetSource = await transform.readInputAsString(id);
    Asset asset = new Asset.fromString(id, _transform(source: assetSource));
    transform.addOutput(asset);
  }

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

      annotatedProperties.forEach((ClassMember property) {
        String before = source.substring(0, property.beginToken.offset);
        String after = source.substring(property.endToken.offset);

        String propertyName = 'propertyName';

        String getterSource = "get $propertyName => this[$propertyName];";
        String setterSource =
            "  set $propertyName(value) => this[$propertyName] = value";

        String transformedSource =
            '$before' + '$getterSource' + '\n' + '$setterSource' + '$after';

        updatedSource = _transform(source: transformedSource);
      });
    }
    return updatedSource;
  }
}

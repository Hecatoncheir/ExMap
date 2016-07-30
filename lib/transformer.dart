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
    Asset asset =
        new Asset.fromString(id, _transform(assetId: id, source: assetSource));
    transform.addOutput(asset);
  }

  String _transform({AssetId assetId, String source}) {
    CompilationUnit unit = parseCompilationUnit(source);

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

      annotatedProperties.forEach(print);

//        String before = content.substring(0, declaration.endToken.offset);
//        String after = content.substring(declaration.endToken.offset);
//
//        newContent = before + "\n$sourceToInject\n" + after;
    }

    return 'source';
  }
}

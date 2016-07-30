library ex_map_transformer;

import 'package:analyzer/analyzer.dart';
import 'package:barback/barback.dart';

/// CodeTransformers
import 'package:code_transformers/resolver.dart';
import 'package:analyzer/dart/element/element.dart';

/// Smoke
import 'package:smoke/codegen/recorder.dart';
import 'package:smoke/codegen/generator.dart';

import 'package:ex_map/ex_map.dart';

class TransformObjectToMap extends Transformer with ResolverTransformer {
  TransformObjectToMap() {
    resolvers = new Resolvers(dartSdkDirectory);
  }

  TransformObjectToMap.asPlugin();

  String get allowedExtensions => '.dart';

  @override
  applyResolver(Transform transform, Resolver resolver) {
    AssetId id = transform.primaryInput.id;
    Asset asset =
        new Asset.fromString(id, _transform(assetId: id, resolver: resolver));
    transform.addOutput(asset);
  }

  String _transform({AssetId assetId, Resolver resolver}) {
    SmokeCodeGenerator generator = new SmokeCodeGenerator();

    String _recordChecker(lib) {
      return resolver.getImportUri(lib, from: assetId).toString();
    }

    Recorder recorder = new Recorder(generator, _recordChecker);

    LibraryElement library = resolver.getLibrary(assetId);
    library.units.forEach((CompilationUnitElement el) {
      /// Member must be a class and has annotation ExMap
      bool _classMustBeAnnotated(CompilationUnitMember unit) {
        Iterable unitMetaData =
            unit.metadata.map((annotation) => annotation.toString());

        if (unit is ClassDeclaration && unitMetaData.contains('@ExMap'))
          return true;
        return false;
      }

      Iterable annotatedClasses =
          el.unit.declarations.where(_classMustBeAnnotated);

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

        /// Class members
        Iterable annotatedProperties =
            classDeclaration.members.where(_classPropertyMustBeAnnotated);

//        String before = content.substring(0, declaration.endToken.offset);
//        String after = content.substring(declaration.endToken.offset);
//
//        newContent = before + "\n$sourceToInject\n" + after;
      }
    });

    return 'source';
  }
}

library ex_map_transformer;

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

    StringBuffer output = new StringBuffer();
    output.write('/// ExMapTransformed \n');

    // recorder.generator.addDeclaration(cls, name, type);

    recorder.generator
      ..writeImports(output)
      ..writeTopLevelDeclarations(output)
      ..writeStaticConfiguration(output);

    return output.toString();
  }
}

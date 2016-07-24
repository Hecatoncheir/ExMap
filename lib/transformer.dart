library ex_map_transformer;

// @MirrorsUsed(symbols: 'ExMap')
// import 'dart:mirrors';
import 'dart:async';

import 'package:barback/barback.dart';

import 'package:smoke/codegen/generator.dart';
import 'package:smoke/codegen/recorder.dart';

import 'package:code_transformers/resolver.dart';

class TransformObjectToMap extends Transformer with ResolverTransformer {
  SmokeCodeGenerator generator;

  TransformObjectToMap();

  TransformObjectToMap.asPlugin() {
    generator = new SmokeCodeGenerator();
    resolvers = new Resolvers(dartSdkDirectory);
  }

  String get allowedExtensions => '.dart';

  // Future apply(Transform transform) async {
  //   AssetId id = transform.primaryInput.id;
  //   String _source = await transform.primaryInput.readAsString();
  //
  //   Asset asset = new Asset.fromString(id, _source);
  //   transform.addOutput(asset);
  // }

  applyResolver(Transform transform, Resolver resolver) {
    print('test');
    // AssetId id = transform.primaryInput.id;
    // String source = await transform.primaryInput.readAsString();
    // Asset asset = new Asset.fromString(id, 'hi');

    Asset asset = _prepareAsset(transform, resolver);
    transform.addOutput(asset);
  }

  Asset _prepareAsset(Transform transform, Resolver resolver) {
    return new Asset.fromString(transform.primaryInput.id, 'source');
  }
}

library ex_map_transformer;

@MirrorsUsed(symbols: 'ExMap')
import 'dart:mirrors';
import 'dart:async';

import 'package:barback/barback.dart';

class TransformObjectToMap extends Transformer {
  TransformObjectToMap.asPlugin();

  String get allowedExtensions => '.dart';

  Future apply(Transform transform) async {
    AssetId id = transform.primaryInput.id;

    Asset asset = new Asset.fromString(id, 'da');
    transform.addOutput(asset);
  }
}

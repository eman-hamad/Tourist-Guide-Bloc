/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/AbuSimple.jpg
  AssetGenImage get abuSimple =>
      const AssetGenImage('assets/images/AbuSimple.jpg');

  /// File path: assets/images/AbuSimple2.jpg
  AssetGenImage get abuSimple2 =>
      const AssetGenImage('assets/images/AbuSimple2.jpg');

  /// File path: assets/images/AbuSimple3.jpg
  AssetGenImage get abuSimple3 =>
      const AssetGenImage('assets/images/AbuSimple3.jpg');

  /// File path: assets/images/CairoTower.jpg
  AssetGenImage get cairoTower =>
      const AssetGenImage('assets/images/CairoTower.jpg');

  /// File path: assets/images/CairoTower2.jpg
  AssetGenImage get cairoTower2 =>
      const AssetGenImage('assets/images/CairoTower2.jpg');

  /// File path: assets/images/EgyptianMuseum.jpg
  AssetGenImage get egyptianMuseum =>
      const AssetGenImage('assets/images/EgyptianMuseum.jpg');

  /// File path: assets/images/EgyptianMuseum2.jpg
  AssetGenImage get egyptianMuseum2 =>
      const AssetGenImage('assets/images/EgyptianMuseum2.jpg');

  /// File path: assets/images/GrandMuseum.jpg
  AssetGenImage get grandMuseum =>
      const AssetGenImage('assets/images/GrandMuseum.jpg');

  /// File path: assets/images/GrandMuseum2.jpg
  AssetGenImage get grandMuseum2 =>
      const AssetGenImage('assets/images/GrandMuseum2.jpg');

  /// File path: assets/images/Karnak.jpg
  AssetGenImage get karnak => const AssetGenImage('assets/images/Karnak.jpg');

  /// File path: assets/images/Karnak2.jpg
  AssetGenImage get karnak2 => const AssetGenImage('assets/images/Karnak2.jpg');

  /// File path: assets/images/arrowBack.png
  AssetGenImage get arrowBack =>
      const AssetGenImage('assets/images/arrowBack.png');

  /// File path: assets/images/card_bg.png
  AssetGenImage get cardBg => const AssetGenImage('assets/images/card_bg.png');

  /// File path: assets/images/minya1.jpg
  AssetGenImage get minya1 => const AssetGenImage('assets/images/minya1.jpg');

  /// File path: assets/images/minya2.jpg
  AssetGenImage get minya2 => const AssetGenImage('assets/images/minya2.jpg');

  /// File path: assets/images/minya3.jpg
  AssetGenImage get minya3 => const AssetGenImage('assets/images/minya3.jpg');

  /// File path: assets/images/minya4.jpg
  AssetGenImage get minya4 => const AssetGenImage('assets/images/minya4.jpg');

  /// File path: assets/images/minya5.jpg
  AssetGenImage get minya5 => const AssetGenImage('assets/images/minya5.jpg');

  /// File path: assets/images/profile.png
  AssetGenImage get profile => const AssetGenImage('assets/images/profile.png');

  /// File path: assets/images/pyramids.jpg
  AssetGenImage get pyramids =>
      const AssetGenImage('assets/images/pyramids.jpg');

  /// File path: assets/images/pyramids2.jpg
  AssetGenImage get pyramids2 =>
      const AssetGenImage('assets/images/pyramids2.jpg');

  /// File path: assets/images/pyramids3.jpg
  AssetGenImage get pyramids3 =>
      const AssetGenImage('assets/images/pyramids3.jpg');

  /// File path: assets/images/sphinx.jpg
  AssetGenImage get sphinx => const AssetGenImage('assets/images/sphinx.jpg');

  /// File path: assets/images/sphinx2.jpg
  AssetGenImage get sphinx2 => const AssetGenImage('assets/images/sphinx2.jpg');

  /// File path: assets/images/sphinx3.jpg
  AssetGenImage get sphinx3 => const AssetGenImage('assets/images/sphinx3.jpg');

  /// File path: assets/images/splash_animation.json
  String get splashAnimation => 'assets/images/splash_animation.json';

  /// List of all assets
  List<dynamic> get values => [
        abuSimple,
        abuSimple2,
        abuSimple3,
        cairoTower,
        cairoTower2,
        egyptianMuseum,
        egyptianMuseum2,
        grandMuseum,
        grandMuseum2,
        karnak,
        karnak2,
        arrowBack,
        cardBg,
        minya1,
        minya2,
        minya3,
        minya4,
        minya5,
        profile,
        pyramids,
        pyramids2,
        pyramids3,
        sphinx,
        sphinx2,
        sphinx3,
        splashAnimation
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

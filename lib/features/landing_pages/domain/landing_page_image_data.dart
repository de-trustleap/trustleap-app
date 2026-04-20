// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:flutter/foundation.dart";

class LandingPageImageData {
  final Uint8List? mainImage;
  final bool mainImageHasChanged;
  final Uint8List? faviconImage;
  final bool faviconImageHasChanged;
  final Uint8List? shareImage;
  final bool shareImageHasChanged;

  const LandingPageImageData({
    required this.mainImage,
    required this.mainImageHasChanged,
    required this.faviconImage,
    required this.faviconImageHasChanged,
    required this.shareImage,
    required this.shareImageHasChanged,
  });

  const LandingPageImageData.empty()
      : mainImage = null,
        mainImageHasChanged = false,
        faviconImage = null,
        faviconImageHasChanged = false,
        shareImage = null,
        shareImageHasChanged = false;

  LandingPageImageData copyWith({
    Uint8List? mainImage,
    bool? mainImageHasChanged,
    Uint8List? faviconImage,
    bool? faviconImageHasChanged,
    Uint8List? shareImage,
    bool? shareImageHasChanged,
  }) {
    return LandingPageImageData(
      mainImage: mainImage ?? this.mainImage,
      mainImageHasChanged: mainImageHasChanged ?? this.mainImageHasChanged,
      faviconImage: faviconImage ?? this.faviconImage,
      faviconImageHasChanged:
          faviconImageHasChanged ?? this.faviconImageHasChanged,
      shareImage: shareImage ?? this.shareImage,
      shareImageHasChanged: shareImageHasChanged ?? this.shareImageHasChanged,
    );
  }
}

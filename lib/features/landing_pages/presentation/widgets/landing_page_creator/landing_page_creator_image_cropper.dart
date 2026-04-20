import "dart:typed_data";
import "dart:ui" as ui;

import "package:finanzbegleiter/core/widgets/shared_elements/widgets/primary_button.dart";
import "package:finanzbegleiter/core/widgets/shared_elements/widgets/secondary_button.dart";
import "package:finanzbegleiter/l10n/generated/app_localizations.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

/// Shows a dialog that lets the user pan and pinch-to-zoom the image
/// inside a fixed crop frame with the given [aspectRatio].
/// Returns the cropped image bytes on confirm, or null on cancel.
Future<Uint8List?> showImageCropDialog(
  BuildContext context,
  Uint8List imageBytes, {
  required double aspectRatio,
  required String aspectRatioLabel,
}) {
  return showDialog<Uint8List>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ImageCropDialog(
      imageBytes: imageBytes,
      aspectRatio: aspectRatio,
      aspectRatioLabel: aspectRatioLabel,
    ),
  );
}

// ---------------------------------------------------------------------------
// Dialog
// ---------------------------------------------------------------------------

class _ImageCropDialog extends StatefulWidget {
  final Uint8List imageBytes;
  final double aspectRatio;
  final String aspectRatioLabel;

  const _ImageCropDialog({
    required this.imageBytes,
    required this.aspectRatio,
    required this.aspectRatioLabel,
  });

  @override
  State<_ImageCropDialog> createState() => _ImageCropDialogState();
}

class _ImageCropDialogState extends State<_ImageCropDialog> {
  ui.Image? _image;
  bool _loading = true;
  bool _cropping = false;

  // Current transform state
  double _scale = 1.0;
  Offset _offset = Offset.zero;

  // Scale gesture tracking
  double _scaleAtGestureStart = 1.0;
  Offset _offsetAtGestureStart = Offset.zero;
  Offset _focalPointAtGestureStart = Offset.zero;

  // The size of the crop frame inside the dialog (set via LayoutBuilder)
  Size _cropFrameSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final codec = await ui.instantiateImageCodec(widget.imageBytes);
      final frame = await codec.getNextFrame();
      if (mounted) {
        setState(() {
          _image = frame.image;
          _loading = false;
          _initTransform();
        });
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop(null);
    }
  }

  double get _minScale {
    if (_image == null || _cropFrameSize == Size.zero) return 1.0;
    final imgW = _image!.width.toDouble();
    final imgH = _image!.height.toDouble();
    final frameW = _cropFrameSize.width;
    final frameH = _cropFrameSize.height;
    // Cover: image must fill the entire frame
    return (frameW / imgW) > (frameH / imgH) ? frameW / imgW : frameH / imgH;
  }

  void _initTransform() {
    if (_image == null || _cropFrameSize == Size.zero) return;
    final imgW = _image!.width.toDouble();
    final imgH = _image!.height.toDouble();
    final frameW = _cropFrameSize.width;
    final frameH = _cropFrameSize.height;

    _scale = _minScale;
    _offset = Offset(
      (frameW - imgW * _scale) / 2,
      (frameH - imgH * _scale) / 2,
    );
  }

  Offset _clampOffset(Offset offset, double scale) {
    if (_image == null || _cropFrameSize == Size.zero) return offset;
    final imgW = _image!.width.toDouble();
    final imgH = _image!.height.toDouble();
    final frameW = _cropFrameSize.width;
    final frameH = _cropFrameSize.height;
    // Image must cover the entire crop frame → offset can only be ≤ 0
    final minX = frameW - imgW * scale;
    final minY = frameH - imgH * scale;
    return Offset(
      offset.dx.clamp(minX, 0.0),
      offset.dy.clamp(minY, 0.0),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _scaleAtGestureStart = _scale;
    _offsetAtGestureStart = _offset;
    _focalPointAtGestureStart = details.localFocalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final newScale = (_scaleAtGestureStart * details.scale)
        .clamp(_minScale, _minScale * 6.0);

    // Pan delta
    final focalDelta = details.localFocalPoint - _focalPointAtGestureStart;

    // Keep the focal point fixed in image-space while zooming
    final focalInImage =
        (_focalPointAtGestureStart - _offsetAtGestureStart) /
            _scaleAtGestureStart;
    final newOffsetFromZoom =
        _focalPointAtGestureStart - focalInImage * newScale;

    final newOffset =
        _clampOffset(newOffsetFromZoom + focalDelta, newScale);

    setState(() {
      _scale = newScale;
      _offset = newOffset;
    });
  }

  /// Handles trackpad pinch and mouse-wheel scroll → zoom around pointer.
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      // Trackpad pinch arrives as scroll with scale != 1 on some platforms,
      // but on Flutter Web/desktop it typically comes as scrollDelta.
      // We treat vertical scroll delta as zoom.
      const kZoomFactor = 0.003;
      final delta = -event.scrollDelta.dy * kZoomFactor;
      final newScale =
          (_scale * (1.0 + delta)).clamp(_minScale, _minScale * 6.0);

      final focalPoint = event.localPosition;
      final focalInImage = (focalPoint - _offset) / _scale;
      final newOffset =
          _clampOffset(focalPoint - focalInImage * newScale, newScale);

      setState(() {
        _scale = newScale;
        _offset = newOffset;
      });
    } else if (event is PointerScaleEvent) {
      // Trackpad pinch on macOS/iOS Flutter delivers PointerScaleEvent
      final newScale =
          (_scale * event.scale).clamp(_minScale, _minScale * 6.0);

      // Zoom around center of crop frame
      final focalPoint = Offset(
        _cropFrameSize.width / 2,
        _cropFrameSize.height / 2,
      );
      final focalInImage = (focalPoint - _offset) / _scale;
      final newOffset =
          _clampOffset(focalPoint - focalInImage * newScale, newScale);

      setState(() {
        _scale = newScale;
        _offset = newOffset;
      });
    }
  }

  Future<void> _onConfirm() async {
    if (_image == null) return;
    setState(() => _cropping = true);

    final imgW = _image!.width.toDouble();
    final imgH = _image!.height.toDouble();
    final frameW = _cropFrameSize.width;
    final frameH = _cropFrameSize.height;

    // Crop rect in image-space coordinates
    final cropX = (-_offset.dx / _scale).clamp(0.0, imgW);
    final cropY = (-_offset.dy / _scale).clamp(0.0, imgH);
    final cropW = (frameW / _scale).clamp(0.0, imgW - cropX);
    final cropH = (frameH / _scale).clamp(0.0, imgH - cropY);

    // Output: cap at 1200 px wide, maintain aspect ratio
    const maxOutputWidth = 1200.0;
    final outputW = cropW.clamp(1.0, maxOutputWidth);
    final outputH = outputW / widget.aspectRatio;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, outputW, outputH),
    );

    canvas.drawImageRect(
      _image!,
      Rect.fromLTWH(cropX, cropY, cropW, cropH),
      Rect.fromLTWH(0, 0, outputW, outputH),
      Paint()..filterQuality = FilterQuality.high,
    );

    final picture = recorder.endRecording();
    final croppedImage =
        await picture.toImage(outputW.round(), outputH.round());
    final byteData =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);

    if (mounted && byteData != null) {
      Navigator.of(context).pop(byteData.buffer.asUint8List());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final screenSize = MediaQuery.sizeOf(context);

    final maxDialogWidth = widget.aspectRatio <= 1.0 ? 400.0 : 700.0;
    final dialogWidth = (screenSize.width * 0.9).clamp(280.0, maxDialogWidth);
    final cropFrameWidth = dialogWidth - 48; // 24 px padding each side
    final cropFrameHeight = cropFrameWidth / widget.aspectRatio;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: dialogWidth,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.landingpage_creator_crop_dialog_title,
                style: themeData.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                localization.landingpage_creator_crop_dialog_hint(widget.aspectRatioLabel),
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              // ── Crop frame ──────────────────────────────────────────────
              LayoutBuilder(builder: (context, _) {
                final newSize = Size(cropFrameWidth, cropFrameHeight);
                if (_cropFrameSize != newSize) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _cropFrameSize = newSize;
                        if (!_loading) _initTransform();
                      });
                    }
                  });
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: cropFrameWidth,
                    height: cropFrameHeight,
                    color: Colors.black,
                    child: _loading || _image == null
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Listener(
                            onPointerSignal: _onPointerSignal,
                            child: GestureDetector(
                              onScaleStart: _onScaleStart,
                              onScaleUpdate: _onScaleUpdate,
                              child: CustomPaint(
                                size: Size(cropFrameWidth, cropFrameHeight),
                                painter: _CropPainter(
                                  image: _image!,
                                  scale: _scale,
                                  offset: _offset,
                                ),
                              ),
                            ),
                          ),
                  ),
                );
              }),

              const SizedBox(height: 8),
              Text(
                localization.landingpage_creator_crop_dialog_gesture_hint,
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // ── Buttons ─────────────────────────────────────────────────
              Row(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 3,
                    child: SecondaryButton(
                      title: localization.cancel_buttontitle,
                      disabled: _cropping,
                      onTap: () => Navigator.of(context).pop(null),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 3,
                    child: PrimaryButton(
                      title: localization.landingpage_creator_crop_dialog_confirm,
                      disabled: _loading,
                      isLoading: _cropping,
                      onTap: _onConfirm,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

class _CropPainter extends CustomPainter {
  final ui.Image image;
  final double scale;
  final Offset offset;

  const _CropPainter({
    required this.image,
    required this.scale,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final srcRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dstRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      image.width * scale,
      image.height * scale,
    );

    canvas.drawImageRect(
      image,
      srcRect,
      dstRect,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(_CropPainter old) =>
      old.image != image || old.scale != scale || old.offset != offset;
}

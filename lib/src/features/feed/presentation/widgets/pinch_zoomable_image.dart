import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'network_image_tile.dart';

class PinchZoomableImage extends StatefulWidget {
  const PinchZoomableImage({
    super.key,
    required this.imageUrl,
    this.onDoubleTap,
  });

  final String imageUrl;
  final VoidCallback? onDoubleTap;

  @override
  State<PinchZoomableImage> createState() => _PinchZoomableImageState();
}

class _PinchZoomableImageState extends State<PinchZoomableImage>
    with SingleTickerProviderStateMixin {
  static const double _webWheelZoomFactor = 0.0012;
  static const double _webDragZoomFactor = 0.0042;

  final GlobalKey _imageKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  late final AnimationController _resetController;

  Offset _offset = Offset.zero;
  Offset _baseOffset = Offset.zero;
  double _scale = 1;
  double _baseScale = 1;
  Rect _originRect = Rect.zero;
  bool _isZooming = false;
  bool _canAttemptZoom = false;
  bool _isPointerInside = false;
  Timer? _webWheelEndTimer;

  @override
  void initState() {
    super.initState();
    _resetController =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 220),
          )
          ..addListener(_onResetTick)
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              _removeOverlay();
            }
          });
  }

  @override
  void dispose() {
    _webWheelEndTimer?.cancel();
    _removeOverlay();
    _resetController
      ..removeListener(_onResetTick)
      ..dispose();
    super.dispose();
  }

  void _onResetTick() {
    final double t = Curves.easeOut.transform(_resetController.value);
    _scale = _lerpDouble(_baseScale, 1, t);
    _offset = Offset.lerp(_baseOffset, Offset.zero, t) ?? Offset.zero;
    _overlayEntry?.markNeedsBuild();
  }

  double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  bool _captureImageRect() {
    final BuildContext? imageContext = _imageKey.currentContext;
    if (imageContext == null) {
      return false;
    }

    final RenderBox box = imageContext.findRenderObject()! as RenderBox;
    _originRect = box.localToGlobal(Offset.zero) & box.size;
    return true;
  }

  void _insertOverlay() {
    if (_overlayEntry != null) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        final double dimOpacity = ((_scale - 1) * 0.2).clamp(0, 0.35);
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: dimOpacity),
                ),
              ),
              Positioned(
                left: _originRect.left + _offset.dx,
                top: _originRect.top + _offset.dy,
                width: _originRect.width,
                height: _originRect.height,
                child: Transform.scale(
                  scale: _scale,
                  child: ClipRect(
                    child: NetworkImageTile(imageUrl: widget.imageUrl),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _startZoomOverlayIfNeeded() {
    if (_isZooming) {
      return;
    }
    if (_originRect == Rect.zero && !_captureImageRect()) {
      return;
    }
    _insertOverlay();
    setState(() => _isZooming = true);
  }

  void _animateBackToOrigin() {
    _webWheelEndTimer?.cancel();
    if (!_isZooming) {
      return;
    }
    _resetController
      ..value = 0
      ..forward();
  }

  bool _isZoomModifierPressed() {
    final Set<LogicalKeyboardKey> keys =
        HardwareKeyboard.instance.logicalKeysPressed;
    return keys.contains(LogicalKeyboardKey.shift) ||
        keys.contains(LogicalKeyboardKey.shiftLeft) ||
        keys.contains(LogicalKeyboardKey.shiftRight) ||
        keys.contains(LogicalKeyboardKey.alt) ||
        keys.contains(LogicalKeyboardKey.altLeft) ||
        keys.contains(LogicalKeyboardKey.altRight);
  }

  double _scaleDeltaFromScroll(PointerScrollEvent event) {
    // On web, Shift+trackpad can surface as horizontal scroll (dx) instead of
    // vertical (dy), so we use whichever axis has the stronger delta.
    final double primaryDelta =
        event.scrollDelta.dy.abs() >= event.scrollDelta.dx.abs()
        ? event.scrollDelta.dy
        : event.scrollDelta.dx;
    return (-primaryDelta * _webWheelZoomFactor).clamp(-0.18, 0.18);
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!kIsWeb || event is! PointerScrollEvent || !_isPointerInside) {
      return;
    }

    // Only treat wheel/trackpad signal as zoom intent when Shift/Alt is pressed.
    // This avoids Ctrl/Cmd browser zoom conflicts and keeps normal feed scroll smooth.
    if (!_isZoomModifierPressed()) {
      return;
    }

    if (_originRect == Rect.zero && !_captureImageRect()) {
      return;
    }

    _resetController.stop();
    _startZoomOverlayIfNeeded();

    final double scaleDelta = _scaleDeltaFromScroll(event);
    if (scaleDelta.abs() < 0.001) {
      return;
    }
    _scale = (_scale + scaleDelta).clamp(1.0, 3.0);
    _baseScale = _scale;
    _baseOffset = _offset;
    _overlayEntry?.markNeedsBuild();

    _webWheelEndTimer?.cancel();
    _webWheelEndTimer = Timer(const Duration(milliseconds: 180), () {
      if (!mounted) {
        return;
      }
      _animateBackToOrigin();
    });
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _canAttemptZoom =
        details.pointerCount >= 2 || (kIsWeb && _isZoomModifierPressed());
    if (!_canAttemptZoom) {
      return;
    }

    if (!_captureImageRect()) {
      return;
    }

    _resetController.stop();
    _scale = 1;
    _baseScale = 1;
    _offset = Offset.zero;
    _baseOffset = Offset.zero;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (!_canAttemptZoom) {
      return;
    }

    final double nextScale = details.scale.clamp(1.0, 3.0);
    final bool modifierDragIntent =
        kIsWeb &&
        details.pointerCount == 1 &&
        _isZoomModifierPressed() &&
        details.focalPointDelta.dy.abs() > 0.25;

    if (!_isZooming) {
      final bool webScaleIntent = kIsWeb && (nextScale - 1).abs() > 0.01;
      final bool touchScaleIntent = details.pointerCount >= 2;
      if (!(webScaleIntent || touchScaleIntent || modifierDragIntent)) {
        return;
      }

      if (_originRect == Rect.zero && !_captureImageRect()) {
        return;
      }

      _startZoomOverlayIfNeeded();
    }

    if (modifierDragIntent) {
      // Shift + drag fallback for web: drag up to zoom in, drag down to zoom out.
      _scale = (_scale - (details.focalPointDelta.dy * _webDragZoomFactor))
          .clamp(1.0, 3.0);
    } else {
      _scale = nextScale;
      _offset += details.focalPointDelta;
    }
    _baseScale = _scale;
    _baseOffset = _offset;
    _overlayEntry?.markNeedsBuild();
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _canAttemptZoom = false;
    if (!_isZooming) {
      return;
    }
    _resetController
      ..value = 0
      ..forward();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isZooming = false;
        _offset = Offset.zero;
        _baseOffset = Offset.zero;
        _scale = 1;
        _baseScale = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isPointerInside = true,
      onExit: (_) {
        _isPointerInside = false;
        _animateBackToOrigin();
      },
      child: Listener(
        onPointerSignal: _handlePointerSignal,
        child: GestureDetector(
          key: _imageKey,
          behavior: HitTestBehavior.opaque,
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          onScaleEnd: _handleScaleEnd,
          onDoubleTap: widget.onDoubleTap,
          child: Opacity(
            opacity: _isZooming ? 0 : 1,
            child: NetworkImageTile(imageUrl: widget.imageUrl),
          ),
        ),
      ),
    );
  }
}

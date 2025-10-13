import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ZoomControlsAnchor { topLeft, topRight, bottomLeft, bottomRight }

class ZoomableCanvas extends StatefulWidget {
  const ZoomableCanvas({
    super.key,
    required this.child,
    this.minScale = 0.5,
    this.maxScale = 6.0,
    this.step = 1.25,
    this.showControls = true,
    this.anchor = ZoomControlsAnchor.bottomRight, // <-- NOVO
  });

  final Widget child;
  final double minScale, maxScale, step;
  final bool showControls;
  final ZoomControlsAnchor anchor; // <-- NOVO

  @override
  State<ZoomableCanvas> createState() => ZoomableCanvasState();
}

class ZoomableCanvasState extends State<ZoomableCanvas> {
  final TransformationController _tc = TransformationController();

  double get _scale => _tc.value.getMaxScaleOnAxis();

  void zoomIn() => _animateTo(
    (_scale * widget.step).clamp(widget.minScale, widget.maxScale),
  );
  void zoomOut() => _animateTo(
    (_scale / widget.step).clamp(widget.minScale, widget.maxScale),
  );
  void resetZoom() => _animateTo(1.0);

  void _animateTo(double targetScale) {
    setState(() {
      _tc.value = Matrix4.identity()..scale(targetScale);
    });
  }

  void _toggleDoubleTap() {
    final next = (_scale - 1.0).abs() < 0.05
        ? math.min(2.0, widget.maxScale)
        : 1.0;
    _animateTo(next);
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).padding;
    const offset = 12.0;

    // calcula posicionamento conforme âncora
    Positioned controls(Widget child) {
      switch (widget.anchor) {
        case ZoomControlsAnchor.topLeft:
          return Positioned(
            left: offset + pad.left,
            top: offset + pad.top,
            child: child,
          );
        case ZoomControlsAnchor.topRight:
          return Positioned(
            right: offset + pad.right,
            top: offset + pad.top,
            child: child,
          );
        case ZoomControlsAnchor.bottomLeft:
          return Positioned(
            left: offset + pad.left,
            bottom: offset + pad.bottom,
            child: child,
          );
        case ZoomControlsAnchor.bottomRight:
          return Positioned(
            right: offset + pad.right,
            bottom: offset + pad.bottom,
            child: child,
          );
      }
    }

    final ctrl = Material(
      color: Colors.black.withOpacity(0.22),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Zoom out',
            icon: const Icon(Icons.remove),
            onPressed: zoomOut,
          ),
          IconButton(
            tooltip: 'Reset',
            icon: const Icon(Icons.center_focus_strong),
            onPressed: resetZoom,
          ),
          IconButton(
            tooltip: 'Zoom in',
            icon: const Icon(Icons.add),
            onPressed: zoomIn,
          ),
        ],
      ),
    );

    return GestureDetector(
      onDoubleTap: _toggleDoubleTap,
      child: Stack(
        children: [
          InteractiveViewer(
            transformationController: _tc,
            minScale: widget.minScale,
            maxScale: widget.maxScale,
            panEnabled: true,
            scaleEnabled: true,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            clipBehavior: Clip.none,
            child: widget.child,
          ),
          if (widget.showControls) controls(ctrl),
        ],
      ),
    );
  }
}

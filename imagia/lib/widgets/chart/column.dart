import 'package:flutter/material.dart';

class ChartColumn extends StatefulWidget {

  final double width;
  final double value;
  final Color color;
  final String label;
  final double divider;

  const ChartColumn({
    super.key, 
    required this.value,
    required this.divider,
    this.label = "",
    this.width = 20,
    this.color = Colors.blue
  });

  @override
  State<ChartColumn> createState() => _ChartColumnState();
}

class _ChartColumnState extends State<ChartColumn> {
  OverlayEntry? _overlayEntry;
  Offset _hoverOffset = Offset.zero;
  bool _hovering = false;

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
        final localPosition = overlay.globalToLocal(_hoverOffset);

        return Positioned(
          left: localPosition.dx + 10, // desplazamos para no tapar el puntero
          top: localPosition.dy + 10,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(widget.value*widget.divider).toInt()}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showOverlay(PointerEvent event) {
    setState(() {
      _hovering = true;
    });
    
    _hoverOffset = event.position;
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _hideOverlay() {
    setState(() {
      _hovering = false;
    });
    
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _showOverlay(event),
      onExit: (event) => _hideOverlay(),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: widget.width,
              height: double.infinity,
              child: CustomPaint(
                painter: ChartColumnPainter(width: widget.width, value: widget.value, color: widget.color, isHovering: _hovering),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

class ChartColumnPainter extends CustomPainter {
  final double width;
  final double value;
  final Color color;
  final bool isHovering;

  ChartColumnPainter({
    required this.width,
    required this.value,
    required this.color,
    required this.isHovering
  });

  @override
  void paint(Canvas canvas, Size size) {

    final double barHeight = size.height * value / 100;

    final paint = Paint()
      ..color = isHovering ? color.withOpacity(0.5) : color
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width / 2 - width / 2,
        size.height - barHeight,
        width,
        barHeight,
      ),
      const Radius.circular(5),
      
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant ChartColumnPainter oldDelegate) {
    return oldDelegate.isHovering != isHovering ||
           oldDelegate.value != value ||
           oldDelegate.width != width ||
           oldDelegate.color != color;
  }
}
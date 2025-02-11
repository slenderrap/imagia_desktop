import 'package:flutter/material.dart';
import 'package:imagia/widgets/chart/column.dart';

class Chart extends StatefulWidget {

  final Map<String,int> data;
  final double width;
  final double height;
  final String title;

  const Chart({
    super.key, 
    required this.data,
    required this.title,
    this.width = -1,
    this.height = 100
  });

  @override
  ChartState createState() => ChartState();
}

class ChartState extends State<Chart> {

  double divider = 0;

  @override
  void initState() {
    if(widget.data.isEmpty) {
      divider = 1;
    }else {
      divider = widget.data.values.reduce((value, element) => value > element ? value : element) / 100;
    }
    
  
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Chart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data) {
      print(widget.data);
      divider = widget.data.values.reduce((value, element) => value > element ? value : element) / 100;
    }
  }

  @override
  Widget build(BuildContext context) {

    double availableWidth = widget.width == -1 ? double.infinity : widget.width;
    double paddingInsideCard = 18.0 * 2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          width: availableWidth == double.infinity ? null : availableWidth - paddingInsideCard,
          height: widget.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                )
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double chartWidth = constraints.maxWidth < 200 ? 200 : constraints.maxWidth;
                    double columnWidth = chartWidth / widget.data.length - 20;
                    
                    return SizedBox(
                      width: chartWidth,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          CustomPaint(
                            painter: ChartGridPainter(),
                            size: Size(chartWidth, widget.height),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: widget.data.keys.map((key) => ChartColumn(
                              value: (widget.data[key] ?? 0)/divider, 
                              divider: divider,
                              width: columnWidth,
                              label: key,
                            )).toList(),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              LayoutBuilder(builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.data.keys.map((key)=>
                  SizedBox(
                    height: 140,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(key),
                    ),
                  )
                ).toList()
                );
                
              })
            ],
          )
        ),
      ),
    );
  }
}

class ChartGridPainter extends CustomPainter {
  final int numberOfLines;
  final Color lineColor;

  ChartGridPainter({
    this.numberOfLines = 5,
    this.lineColor = const Color.fromARGB(255, 197, 197, 197),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Dibujar las líneas horizontales
    for (int i = 0; i < numberOfLines; i++) {
      // Calcula la posición Y: se distribuyen uniformemente de abajo hacia arriba.
      final y = size.height - (size.height / (numberOfLines - 1)) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
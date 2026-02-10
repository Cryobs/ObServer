import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CircleDiagram extends StatefulWidget {
  final int diagval;
  final String label;
  final String title;
  final String? alternativeLabel;

  const CircleDiagram({
    super.key,
    required this.diagval,
    required this.label,
    required this.title,
    this.alternativeLabel,
  });

  @override
  State<CircleDiagram> createState() => _CircleDiagramState();
}

class _CircleDiagramState extends State<CircleDiagram> {
  late List<GPData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  bool _showAlternative = false;

  @override
  void initState() {
    super.initState();
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: false);
  }

  @override
  void didUpdateWidget(covariant CircleDiagram oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.diagval != widget.diagval) {
      setState(() {
        _chartData = getChartData();
      });
    }
  }

  void _toggleLabel() {
    if (widget.alternativeLabel != null) {
      setState(() {
        _showAlternative = !_showAlternative;
      });
    }
  }

  double _getFontSize(String text, double baseSize) {
    final len = text.length;
    if (len <= 4) return baseSize;
    if (len <= 7) return baseSize * 0.86;
    if (len <= 10) return baseSize * 0.71;
    return baseSize * 0.57;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;

        final currentLabel = _showAlternative && widget.alternativeLabel != null
            ? widget.alternativeLabel!
            : widget.label;

        final titleFontSize = size * 0.18;
        final labelFontSize = size * 0.18;

        return GestureDetector(
          onTap: _toggleLabel,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: size * 0.05,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  top: size * 0.25,
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: SfCircularChart(
                      backgroundColor: Colors.transparent,
                      palette: <Color>[getColor()],
                      tooltipBehavior: _tooltipBehavior,
                      annotations: [
                        CircularChartAnnotation(
                          widget: Text(
                            currentLabel,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: _getFontSize(currentLabel, labelFontSize),
                              fontWeight: FontWeight.bold,
                              color: getColor(),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      series: [
                        RadialBarSeries<GPData, String>(
                          dataSource: _chartData,
                          xValueMapper: (GPData data, _) => data.label,
                          yValueMapper: (GPData data, _) => data.gdp,
                          maximumValue: 100,
                          radius: '100%',
                          innerRadius: '80%',
                          cornerStyle: CornerStyle.bothCurve,
                          trackColor: getColor(),
                          trackOpacity: 0.3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<GPData> getChartData() {
    return [GPData('Value', widget.diagval)];
  }

  Color getColor() {
    if (widget.diagval < 50) return const Color(0xFF22C55E);
    if (widget.diagval < 90) return const Color(0xFFE5A50A);
    return const Color(0xFFE9220C);
  }
}

class GPData {
  GPData(this.label, this.gdp);
  final String label;
  final int gdp;
}

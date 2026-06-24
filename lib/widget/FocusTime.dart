import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FocusTimerWidget extends StatefulWidget {
  final int initialMinutes;
  final int maxMinutes;
  final ValueChanged<int>? onChanged;

  const FocusTimerWidget({
    super.key,
    required this.initialMinutes,
    required this.maxMinutes,
    this.onChanged,
  });

  @override
  State<FocusTimerWidget> createState() => _FocusTimerWidgetState();
}

class _FocusTimerWidgetState extends State<FocusTimerWidget> {
  late int minutes;

  @override
  void initState() {
    super.initState();
    minutes = widget.initialMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 1,
          maximum: widget.maxMinutes.toDouble(),
          startAngle: 270,
          endAngle: 270,
          showTicks: false,
          showLabels: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.12,
            thicknessUnit: GaugeSizeUnit.factor,
            color: Color(0x33FFFFFF),
          ),
          pointers: <GaugePointer>[
            MarkerPointer(
              value: minutes.toDouble(),
              enableDragging: true,
              markerType: MarkerType.circle,
              color: Colors.white,
              markerWidth: 24,
              markerHeight: 24,
              onValueChanged: (value) {
                setState(() {
                  minutes = value.toInt();
                });
                widget.onChanged?.call(value.toInt());
              },
            ),
            RangePointer(
              value: minutes.toDouble(),
              width: 10,
              color: Colors.white,
              cornerStyle: CornerStyle.bothCurve,
            ),
          ],
        ),
      ],
    );
  }
}
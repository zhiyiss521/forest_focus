import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FocusTimerWidget extends StatefulWidget {
  final double initialMinutes;
  final double maxMinutes;
  final ValueChanged<double>? onChanged;

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
  late double minutes;

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
          maximum: widget.maxMinutes,
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
              value: minutes,
              enableDragging: true,
              markerType: MarkerType.circle,
              color: Colors.white,
              markerWidth: 24,
              markerHeight: 24,
              onValueChanged: (value) {
                setState(() {
                  minutes = value;
                });
                widget.onChanged?.call(value);
              },
            ),
            RangePointer(
              value: minutes,
              width: 12,
              color: Colors.white,
              cornerStyle: CornerStyle.bothCurve,
            ),
          ],
          // annotations: <GaugeAnnotation>[
          //   GaugeAnnotation(
          //     angle: 90,
          //     positionFactor: 0.1,
          //     widget: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           minutes.round().toString(),
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 64,
          //             fontWeight: FontWeight.w700,
          //           ),
          //         ),
          //         const Text(
          //           "minutes",
          //           style: TextStyle(
          //             color: Colors.white70,
          //             fontSize: 18,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
        ),
      ],
    );
  }
}
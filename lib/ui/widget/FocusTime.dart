import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FocusTimerWidget extends StatefulWidget {
  /// 当前分钟数
  final int initialMinutes;

  /// 最小分钟数
  final int minMinutes;

  /// 最大分钟数
  final int maxMinutes;

  /// 步进值
  final int step;

  final ValueChanged<int>? onChanged;

  const FocusTimerWidget({
    super.key,
    required this.initialMinutes,
    required this.maxMinutes,
    this.minMinutes = 1,
    this.step = 1,
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
    minutes = _snap(widget.initialMinutes);
  }

  @override
  void didUpdateWidget(covariant FocusTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialMinutes != widget.initialMinutes ||
        oldWidget.minMinutes != widget.minMinutes ||
        oldWidget.maxMinutes != widget.maxMinutes ||
        oldWidget.step != widget.step) {
      minutes = _snap(widget.initialMinutes);
    }
  }

  /// 吸附到最近的 step，并限制在 min ~ max 之间
  int _snap(num value) {
    final step = widget.step <= 0 ? 1 : widget.step;

    final snapped = (((value.toDouble() - widget.minMinutes) / step).round() *
        step +
        widget.minMinutes);

    return snapped.clamp(widget.minMinutes, widget.maxMinutes).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: widget.minMinutes.toDouble(),
          maximum: widget.maxMinutes.toDouble(),
          startAngle: 270,
          endAngle: 270,
          showTicks: false,
          showLabels: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.12,
            thicknessUnit: GaugeSizeUnit.factor,
            color: Color(0xFFD9C2A0),
          ),
          pointers: [
            RangePointer(
              value: minutes.toDouble(),
              width: 0.12,
              sizeUnit: GaugeSizeUnit.factor,
              color: const Color(0xFF83C26F),
              cornerStyle: CornerStyle.bothCurve,
            ),
            MarkerPointer(
              value: minutes.toDouble(),
              enableDragging: true,
              markerType: MarkerType.circle,
              color: const Color(0xFFD7B98D),
              borderColor: const Color(0xFFC9AA7A),
              borderWidth: 3,
              markerWidth: 24,
              markerHeight: 24,
              onValueChanging: (args) {
                args.value = _snap(args.value).toDouble();
              },
              onValueChanged: (value) {
                final newValue = _snap(value);

                if (newValue == minutes) return;

                setState(() {
                  minutes = newValue;
                });

                widget.onChanged?.call(newValue);
              },
            ),
          ],
        ),
      ],
    );
  }
}
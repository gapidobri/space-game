import 'package:flutter/material.dart';

class MenuSlider extends StatefulWidget {
  const MenuSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.onChangeEnd,
  });
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  @override
  State<MenuSlider> createState() => _MenuSliderState();
}

class _MenuSliderState extends State<MenuSlider> {
  late double _localValue;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value.clamp(0.0, 1.0);
  }

  @override
  void didUpdateWidget(covariant MenuSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _localValue = widget.value.clamp(0.0, 1.0);
    }
  }

  void _updateValue(Offset localPosition, double width) {
    final value = (localPosition.dx / width).clamp(0.0, 1.0);
    setState(() => _localValue = value);
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double trackHeight = 8;
        const double thumbWidth = 18;
        const double thumbHeight = 28;

        final width = constraints.maxWidth;
        final thumbX = _localValue * (width - thumbWidth);

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (details) {
            _updateValue(details.localPosition, width);
          },
          onHorizontalDragUpdate: (details) {
            _updateValue(details.localPosition, width);
          },
          onHorizontalDragEnd: (_) {
            widget.onChangeEnd?.call(_localValue);
          },
          onTapDown: (details) {
            _updateValue(details.localPosition, width);
            widget.onChangeEnd?.call(_localValue);
          },
          child: SizedBox(
            height: thumbHeight,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // White base line
                Positioned(
                  left: 0,
                  right: 0,
                  child: Container(height: trackHeight, color: Colors.white),
                ),

                // Black rectangle thumb
                Positioned(
                  left: thumbX,
                  child: Container(
                    width: thumbWidth,
                    height: thumbHeight,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

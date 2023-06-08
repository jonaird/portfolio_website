import 'package:flutter/material.dart';
import 'dart:ui';

class AnimatedBlur extends ImplicitlyAnimatedWidget {
  const AnimatedBlur({
    super.key,
    required this.child,
    super.curve,
    super.duration = const Duration(milliseconds: 400),
    super.onEnd,
    required this.blur,
  });
  final Widget child;
  final double blur;

  @override
  AnimatedWidgetBaseState<AnimatedBlur> createState() => _AnimatedBlurState();
}

class _AnimatedBlurState extends AnimatedWidgetBaseState<AnimatedBlur> {
  Tween<double>? _blurValue;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _blurValue = visitor(_blurValue, widget.blur,
        (value) => Tween<double>(begin: value as double)) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _blurValue!.evaluate(animation),
              sigmaY: _blurValue!.evaluate(animation),
              // sigmaX: 4.0,
              // sigmaY: 4.0,
            ),
            child: Container(),
          ),
        ),
      ],
    );
  }
}

import 'package:website/main.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class MotionBlur extends StatefulWidget {
  const MotionBlur({super.key, required this.child});
  final Widget child;

  @override
  State<MotionBlur> createState() => _MotionBlurState();
}

class _MotionBlurState extends State<MotionBlur> {
  Size? prevSize;
  Offset? prevPosition;
  ui.Image? prevFrame;
  late RenderBox myRenderObject;

  void _setRenderObject(RenderBox box) {
    // myRenderObject = box;
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder((context, shader, child) {
      final animating = context
          .select<FocalPieceViewModel, bool>((vm) => vm.animating.value)!;
      return AnimatedSampler(enabled: animating, (image, size, canvas) {
        final prevFrames = context.read<FocalPieceViewModel>()!.previousFrames;
        final prevFrame0 = prevFrames.isEmpty ? image : prevFrames.first;
        final prevFrame1 = prevFrames.length > 1 ? prevFrames[1] : image;
        // shader.setFloat(0, value);
        // shader.setFloat(1, value);
        shader.setFloat(0, size.width);
        shader.setFloat(1, size.height);
        shader.setImageSampler(0, image);
        // shader.setImageSampler(1, prevFrame0);
        // shader.setImageSampler(2, prevFrame1);

        canvas.drawRect(
          Offset.zero & size,
          Paint()..shader = shader,
        );
      }, child: widget.child);
    }, assetKey: 'shaders/motion_blur.glsl');
    // return widget.child;
    return ShaderBuilder((context, shader, child) {
      final animating = context
          .select<FocalPieceViewModel, bool>((vm) => vm.animating.value)!;
      return AnimatedSampler(
        enabled: animating,
        (image, size, canvas) {
          // final position = myRenderObject.localToGlobal(Offset.zero);
          const position = Offset.zero;
          shader
            ..setFloat(0, size.width)
            ..setFloat(1, size.height)
            // ..setFloat(2, position.dx)
            // ..setFloat(3, position.dy)
            // ..setFloat(4, (prevSize ?? size).width)
            // ..setFloat(5, (prevSize ?? size).height)
            // ..setFloat(6, (prevPosition ?? position).dx)
            // ..setFloat(7, (prevPosition ?? position).dy)
            ..setImageSampler(0, image);
          // ..setImageSampler(1, prevFrame ?? image);
          canvas.drawRect(
            Offset.zero & size,
            Paint()..shader = shader,
          );
          prevSize = size;
          prevFrame = image;
          prevPosition = position;
        },
        child: MotionBlurRenderObjectWidget(
          _setRenderObject,
          child: widget.child,
        ),
      );
    }, assetKey: 'shaders/motion_blur.glsl');
  }
}

class MotionBlurRenderObjectWidget extends SingleChildRenderObjectWidget {
  const MotionBlurRenderObjectWidget(this.setRenderObject,
      {super.key, super.child});
  final void Function(RenderBox) setRenderObject;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MotionBlurRenderObject(setRenderObject);
  }
}

class MotionBlurRenderObject extends RenderProxyBox {
  MotionBlurRenderObject(this.setRenderObject);
  final void Function(RenderBox) setRenderObject;

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    super.layout(constraints, parentUsesSize: parentUsesSize);
    setRenderObject(this);
  }
}

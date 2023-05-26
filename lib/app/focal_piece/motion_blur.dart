import 'package:website/main.dart';
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
  late RenderBox childRenderObject;

  @override
  Widget build(BuildContext context) {
    // return widget.child;
    return ShaderBuilder((context, shader, child) {
      final animating = context
          .select<FocalPieceViewModel, bool>((vm) => vm.animating.value)!;
      return AnimatedSampler(
        enabled: false,
        (frame, size, canvas) {
          final position = (context.findRenderObject()! as RenderBox)
              .localToGlobal(Offset.zero);
          // const position = Offset.zero;
          shader
            ..setFloat(0, size.width)
            ..setFloat(1, size.height)
            // ..setFloat(2, position.dx)
            // ..setFloat(3, position.dy)
            // ..setFloat(4, (prevSize ?? size).width)
            // ..setFloat(5, (prevSize ?? size).height)
            // ..setFloat(6, (prevPosition ?? position).dx)
            // ..setFloat(7, (prevPosition ?? position).dy)
            ..setImageSampler(0, frame)
            ..setImageSampler(1, frame);
          canvas.drawRect(
            Offset.zero & size,
            Paint()..shader = shader,
          );
          prevSize = size;
          prevFrame = frame;
          prevPosition = position;
        },
        child: widget.child,
      );
    }, assetKey: 'shaders/motion_blur.glsl');
  }
}

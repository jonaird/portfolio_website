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
      return AnimatedSampler(
        enabled: context
            .select<FocalPieceViewModel, bool>((vm) => vm.animating.value)!,
        (frame, size, canvas) {
          final position = (context.findRenderObject()! as RenderBox)
              .localToGlobal(Offset.zero);
          // const position = Offset.zero;
          var deltaPosition = (prevPosition ?? position) - position;
          // //Flutter's Y axis starts at the top left of the screen but
          // //our shader's y axis starts at the bottom left
          // deltaPosition = Offset(deltaPosition.dx, -deltaPosition.dy);
          shader
            ..setFloat(0, size.width)
            ..setFloat(1, size.height)
            ..setFloat(2, (prevSize ?? size).width)
            ..setFloat(3, (prevSize ?? size).height)
            ..setFloat(4, deltaPosition.dx)
            ..setFloat(5, deltaPosition.dy)
            ..setImageSampler(0, frame);
          // ..setImageSampler(1, prevFrame ?? frame);
          canvas.drawRect(
            Offset.zero & size,
            Paint()..shader = shader,
          );
          prevSize = size;
          prevFrame?.dispose();
          prevFrame = frame.clone();
          prevPosition = position;
        },
        child: widget.child,
      );
    }, assetKey: 'shaders/motion_blur.glsl');
  }
}

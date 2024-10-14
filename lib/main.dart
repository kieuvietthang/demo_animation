import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: DashedLineAnimation(),
        ),
      ),
    );
  }
}

class DashedLineAnimation extends StatefulWidget {
  @override
  _DashedLineAnimationState createState() => _DashedLineAnimationState();
}

class _DashedLineAnimationState extends State<DashedLineAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Tạo một AnimationController với thời gian hoạt động
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Kéo dài thời gian để vẽ nhiều đoạn
    );

    // Tạo một Tween để giá trị animation đi từ 0.0 -> 1.0
    _animation = Tween<double>(begin: 0.0, end: 2.0).animate(_controller)
      ..addListener(() {
        setState(() {}); // Cập nhật UI khi giá trị animation thay đổi
      });

    // Bắt đầu animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 300),
      painter: DashedLinePainter(progress: _animation.value),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final double progress; // Giá trị animation để vẽ từ từ

  DashedLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Tạo path cho đường đi với nhiều đoạn
    final path = Path();

    // Bắt đầu từ góc dưới bên trái
    path.moveTo(0, size.height);

    // Đoạn 1: Sang phải
    path.lineTo(size.width / 4, size.height);

    // Đoạn 2: Lên trên
    path.lineTo(size.width / 4, size.height * 3 / 4);

    // Đoạn 3: Sang phải
    path.lineTo(size.width / 2, size.height * 3 / 4);

    // Đoạn 4: Lên trên
    path.lineTo(size.width / 2, size.height / 2);

    path.lineTo(size.width - 60, size.height * 1 / 2);
    path.lineTo(size.width * 0.8, size.height / 4);

    // // Đoạn 5: Sang trái
    // path.lineTo(size.width / 2, size.height / 2);
    //
    // // Đoạn 6: Lên trên
    // path.lineTo(size.width / 2, size.height / 4);
    //
    // // Đoạn 7: Sang trái
    // path.lineTo(0, size.height / 4);
    //
    // // Đoạn 8: Lên trên đến góc trên cùng bên trái
    // path.lineTo(0, 0);

    // Vẽ từng phần của đường nét đứt dựa trên progress
    drawDashedPath(canvas, path, paint, progress);
  }

  void drawDashedPath(Canvas canvas, Path path, Paint paint, double progress) {
    final dashWidth = 10.0;
    final dashSpace = 5.0;
    final pathMetrics = path.computeMetrics();

    for (var metric in pathMetrics) {
      var distance = 0.0;
      final totalLength = metric.length * progress; // Vẽ theo tỉ lệ progress

      while (distance < totalLength) {
        final nextDistance = distance + dashWidth;
        final extractPath = metric.extractPath(distance, nextDistance);
        canvas.drawPath(extractPath, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) {
    return oldDelegate.progress != progress; // Vẽ lại khi progress thay đổi
  }
}

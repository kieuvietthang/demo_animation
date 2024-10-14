import 'dart:async';
import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;
  final double progress;

  DashedLinePainter({
    required this.startPoint,
    required this.endPoint,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Parameters for the dashed line
    double dashLength = 10.0; // Length of each dash
    double gapLength = 5.0; // Length of each gap

    // Calculate total distance
    double totalDistance = (endPoint - startPoint).distance;

    // Calculate the number of dashes to draw based on progress
    double totalDashes = (totalDistance / (dashLength + gapLength)) * progress;

    double currentX = startPoint.dx;
    double currentY = startPoint.dy;

    for (int i = 0; i < totalDashes; i++) {
      // Draw dashes
      path.moveTo(currentX, currentY);
      currentX += dashLength;
      if (currentX > endPoint.dx) {
        currentX = endPoint.dx; // Limit to end point
      }
      currentY += (endPoint.dy - startPoint.dy) / totalDistance * dashLength;
      path.lineTo(currentX, currentY);

      // Move to the next gap
      currentX += gapLength;
      if (currentX > endPoint.dx) {
        currentX = endPoint.dx; // Limit to end point
      }
      currentY += (endPoint.dy - startPoint.dy) / totalDistance * gapLength;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DashedLineAnimation extends StatefulWidget {
  @override
  _DashedLineAnimationState createState() => _DashedLineAnimationState();
}

class _DashedLineAnimationState extends State<DashedLineAnimation> {
  double progress = 0.0;
  late Timer timer;
  bool isBVisible = false;
  bool isADimmed = false;

  final Offset startPoint = Offset(50, 450);
  final Offset endPoint = Offset(250, 150);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 0.01; // Tăng dần độ dài đã vẽ

        // Hiển thị điểm B khi vẽ được nửa đoạn
        if (progress >= 0.5 && !isBVisible) {
          isBVisible = true; // Hiện điểm B
        }

        // Đổi màu điểm A sau khi điểm B hiển thị
        if (isBVisible) {
          isADimmed = true; // Đổi màu điểm A
        }

        if (progress >= 1.0) {
          progress = 1.0; // Đặt lại giá trị progress
          timer.cancel();

        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            CustomPaint(
              size: Size(300, 500),
              painter: DashedLinePainter(
                startPoint: startPoint,
                endPoint: endPoint,
                progress: progress,
              ),
            ),
            // Hiển thị điểm A (dưới) với vòng tròn bao quanh
            Positioned(
              left: startPoint.dx - 25,
              top: startPoint.dy - 25,
              child: Container(
                width: 50,
                height: 50,
                child: isADimmed
                    ? Image.asset('assets/images/img_home_disconnect.png')
                    : Image.asset('assets/images/img_home.png'),
              ),
            ),
            // Hiển thị điểm B (trên) với vòng tròn bao quanh
            if (isBVisible)
              Positioned(
                left: endPoint.dx - 25,
                top: endPoint.dy - 25,
                child: Container(
                  width: 50,
                  height: 50,
                  child: Image.asset('assets/images/img_school.png'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DashedLineAnimation(),
  ));
}

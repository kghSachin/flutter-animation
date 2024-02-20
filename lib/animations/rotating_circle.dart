import 'dart:math';

import 'package:flutter/material.dart';

class RotatingCircle extends StatefulWidget {
  const RotatingCircle({super.key});

  @override
  State<RotatingCircle> createState() => RotatingCircleState();
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class RotatingCircleState extends State<RotatingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _counterClockwiseAnimationController;
  late Animation<double> _counterClockwiseRotationAnimation;
  @override
  void initState() {
    _counterClockwiseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _counterClockwiseRotationAnimation =
        Tween<double>(begin: 0, end: -(pi / 2)).animate(CurvedAnimation(
      parent: _counterClockwiseAnimationController,
      curve: Curves.bounceOut,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _counterClockwiseAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      _counterClockwiseAnimationController
        ..reset()
        ..forward.delayed(const Duration(seconds: 2));
    });
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
            animation: _counterClockwiseRotationAnimation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationZ(_counterClockwiseRotationAnimation.value),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ClipPath(
                    clipper: const HalfCircleClipper(side: CircleSide.left),
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.red,
                    ),
                  ),
                  ClipPath(
                    clipper: const HalfCircleClipper(side: CircleSide.right),
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.green,
                    ),
                  ),
                ]),
              );
            }),
      ),
    );
  }
}

enum CircleSide {
  left,
  right,
}

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();
    late Offset offset;
    late bool clockWise;
    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockWise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockWise = true;
        break;
    }
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockWise,
    );
    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

import 'dart:math';

import 'package:flutter/material.dart';

class RotationAnimation extends StatefulWidget {
  const RotationAnimation({super.key});

  @override
  State<RotationAnimation> createState() => RotationAnimationState();
}

class RotationAnimationState extends State<RotationAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  int second = 0;

  String get timeRemaining {
    Duration duration = _controller.duration! * _controller.value;
    return '${duration.inMinutes} ${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    _controller.repeat();
    // _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              // transform: Matrix4.identity()..rotateZ(_animation.value),
              // transform: Matrix4.skew(_animation.value, _animation.value),
              transform: Matrix4.copy(
                Matrix4.identity()..rotateX(_animation.value),
              ),
              child: Stack(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey,
                    child: Center(
                        child: Text(timeRemaining,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30))),
                  ),
                  const Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.green,
                      )),
                  const Positioned(
                      bottom: 0,
                      left: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                      )),
                  const Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black,
                      )),
                  const Positioned(
                      top: 0,
                      left: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.purple,
                      ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

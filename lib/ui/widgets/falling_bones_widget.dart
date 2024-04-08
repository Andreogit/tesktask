import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double angleIncrementation = 0.05;

class BonesWidget extends StatefulWidget {
  ///
  /// Give the amount of particles to display on the screen
  ///
  final int totalBones;

  ///
  /// Give the speed of the bone particles
  ///
  final double speed;

  ///
  /// Tells whether the animation is starting or not
  ///
  final bool isRunning;

  ///
  /// Give the max size of the bone
  ///
  final double maxSize;

  final bool hasSpinningEffect;

  const BonesWidget({
    Key? key,
    required this.totalBones,
    required this.speed,
    required this.isRunning,
    this.maxSize = 50,
    this.hasSpinningEffect = true,
  }) : super(key: key);

  @override
  BonesWidgetState createState() => BonesWidgetState();
}

class BonesWidgetState extends State<BonesWidget> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation animation;

  double W = 0;
  double H = 0;

  final Random _rnd = Random();
  final List<Bone> _bones = [];
  double angle = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BonesWidget oldWidget) {
    if (oldWidget.isRunning == false) {
      for (var element in _bones) {
        element.y = 0;
      }
    }
    if (_hasParametersChanged(oldWidget)) {
      init(hasInit: true, previousTotalSnow: oldWidget.totalBones);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_bones.isEmpty) {
      init();
    }
  }

  bool _hasParametersChanged(covariant BonesWidget oldWidget) {
    return oldWidget.totalBones != widget.totalBones || oldWidget.maxSize != widget.maxSize;
  }

  Future<void> _replaceBoneWithNewParameters(int previousTotalSnow) async {
    List<Bone> copyBones = _bones;

    for (int i = 0; i < previousTotalSnow; i++) {
      final Bone bone = copyBones.elementAt(i);
      final double radius = _rnd.nextDouble() * widget.maxSize + 15;
      final double generatedSize = _rnd.nextDouble() * widget.speed;
      final double speed = generatedSize >= (widget.maxSize - widget.maxSize / 4) ? generatedSize : generatedSize / 3;

      _bones[i] = Bone(
        x: bone.x,
        y: bone.y,
        radius: radius,
        density: speed,
        spinLeft: bone.spinLeft,
        angle: bone.angle,
      );
    }
  }

  Future<void> init({bool hasInit = false, int previousTotalSnow = 0}) async {
    W = MediaQuery.of(context).size.width;
    H = MediaQuery.of(context).size.height;

    if (hasInit) {
      /// only reset balls after the first init is done
      await _replaceBoneWithNewParameters(previousTotalSnow);
      final int newTotalSnow = widget.totalBones - previousTotalSnow;
      if (newTotalSnow > 0) {
        await _createBone(newBallToAdd: newTotalSnow);
      } else {
        _bones.removeRange(0, newTotalSnow.abs());
      }
    } else {
      controller = AnimationController(lowerBound: 0, upperBound: 1, vsync: this, duration: const Duration(seconds: 5))
        ..addListener(() {
          if (mounted) {
            setState(() {
              update();
            });
          }
        });

      controller.repeat();
    }
  }

  @override
  dispose() {
    controller.dispose();

    super.dispose();
  }

  Future<void> _createBone({required int newBallToAdd}) async {

    for (int i = 0; i < newBallToAdd; i++) {
      final double radius = _rnd.nextDouble() * widget.maxSize + 15;
      final double density = _rnd.nextDouble() * widget.speed;

      final double x = _rnd.nextDouble() * W;

      final double y = _rnd.nextDouble() * H * -1;

      _bones.add(
        Bone(
          x: x,
          y: y,
          radius: radius,
          density: density,
          angle: 0,
          spinLeft: _rnd.nextBool(),
        ),
      );
    }
  }

  Future<void> update() async {
    angle += angleIncrementation;

    if (widget.totalBones != _bones.length) {
      await _createBone(newBallToAdd: widget.totalBones);
    }

    for (int i = 0; i < widget.totalBones; i++) {
      final Bone bone = _bones.elementAt(i);
      final double sinX = bone.density;

      bone.y += (cos(angle + bone.density) + bone.radius).abs() * widget.speed;
      bone.x += sin(sinX) * 2 * widget.speed;
      bone.angle += bone.spinLeft ? -angleIncrementation : angleIncrementation;

      if (bone.x > W + (bone.radius) || bone.x < -(bone.radius) || bone.y > H + (bone.radius) || bone.y < -(bone.radius)) {
        if (i % 4 > 0) {
          _bones[i] = Bone(
              x: _rnd.nextDouble() * W, y: -10, radius: bone.radius, density: bone.density, spinLeft: bone.spinLeft, angle: bone.angle);
        } else if (i % 5 > 0) {
          _bones[i] = Bone(
              x: (_rnd.nextDouble() * W) - _rnd.nextDouble() * 10,
              y: 0,
              radius: bone.radius,
              density: bone.density,
              spinLeft: bone.spinLeft,
              angle: bone.angle);
        } else {
          _bones[i] = Bone(
              x: (_rnd.nextDouble() * W) - _rnd.nextDouble() * 10,
              y: -_rnd.nextDouble() * 10,
              radius: bone.radius,
              density: bone.density,
              spinLeft: bone.spinLeft,
              angle: bone.angle);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool running = true;
    if (!widget.isRunning) {
      Future.delayed(const Duration(milliseconds: 500), () {
        running = false;
        setState(() {});
      });
    }
    if (widget.isRunning && !controller.isAnimating) {
      controller.repeat();
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      W = constraints.maxWidth;
      H = constraints.maxHeight;

      return running
          ? Stack(
              children: [
                ..._bones
                    .map(
                      (Bone bone) => Positioned(
                        left: bone.x,
                        top: bone.y,
                        child: Transform.rotate(
                          angle: bone.angle,
                          child: SvgPicture.asset(
                            "assets/icons/bone.svg",
                            width: bone.radius,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            )
          : const SizedBox.shrink();
    });
  }
}

class Bone {
  double x;
  double y;
  double angle;
  bool spinLeft;
  double radius;
  double density;

  Bone({
    required this.angle,
    required this.spinLeft,
    required this.x,
    required this.y,
    required this.radius,
    required this.density,
  });
}

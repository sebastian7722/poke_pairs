import 'dart:math';
import 'package:flutter/material.dart';

import 'cards_card_back.dart';
import 'cards_card_front.dart';

class Card extends StatefulWidget {
  final int id;
  final CardFront cardFront;
  final bool isflipped;
  final bool isFlippable;
  final void Function(int) onTap;

  const Card({
    required this.id,
    required this.cardFront,
    required this.isflipped,
    required this.isFlippable,
    required this.onTap,
    super.key,
  });

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> with TickerProviderStateMixin {
  late AnimationController controller;

  void handleCardAnimation() async {
    if (widget.isflipped) {
      await controller.forward();
      return;
    }

    await controller.reverse();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    handleCardAnimation();
  }

  @override
  void didUpdateWidget(covariant Card oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleCardAnimation();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.id);
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: isBack(angle.abs())
                ? const CardBack()
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: widget.cardFront),
          );
        },
      ),
    );
  }

  bool isBack(double angle) {
    const degrees90 = pi / 2;
    const degrees270 = 3 * pi / 2;

    return angle <= degrees90 || angle >= degrees270;
  }
}

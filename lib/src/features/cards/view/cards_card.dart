import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'cards_card_back.dart';
import 'cards_card_front.dart';
import 'cards_card_model.dart';

class Card extends StatefulWidget {
  final int id;
  final CardFront cardFront;
  final bool isFlipped;
  final bool isFlippable;
  final bool hasPair;
  final void Function(int) onTap;

  const Card({
    required this.id,
    required this.cardFront,
    required this.isFlipped,
    required this.isFlippable,
    required this.hasPair,
    required this.onTap,
    super.key,
  });

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> with TickerProviderStateMixin {
  late AnimationController controller;
  bool cardflipToFrontDone = false;

  void handleCardAnimation(CardsModel provider) async {
    if (controller.isAnimating) return;
    if (widget.isFlipped) {
      final animatingFrom = controller.value;
      print('animation start ${controller.value}');
      await controller.forward();
      print('animation ends ${controller.value}');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (animatingFrom != 1) {
          print('animation ends postframe ${controller.value}');
          provider.flipToFrontDone();
        }
      });
    } else {
      await controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    print('object finished building?');
    //final cardsProvider = Provider.of<CardsModel>(context, listen: false);
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      print('object finished building? SCHEDULER');
    });
    //handleCardAnimation(cardsProvider);
  }

  @override
  void didUpdateWidget(covariant Card oldWidget) {
    print('widget updated');
    super.didUpdateWidget(oldWidget);
    final cardsProvider = Provider.of<CardsModel>(context, listen: false);
    handleCardAnimation(cardsProvider);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('changed deps');
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
        if (controller.isAnimating) return;
        widget.onTap(widget.id);
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);
          final hasTurnedToFront = !isBack(angle.abs());

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: !hasTurnedToFront
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

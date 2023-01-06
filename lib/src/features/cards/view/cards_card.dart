import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'cards_card_back.dart';
import 'cards_card_front.dart';
import 'dart:math' as math;

import 'cards_card_model.dart';

class PokemonCard extends StatefulWidget {
  final int id;
  final CardBack cardBack;
  final bool isScheduledForFlip;
  final bool isFlipped;
  final bool isFlippable;
  final bool hasPair;
  final void Function(int) onTap;

  const PokemonCard({
    required this.id,
    required this.cardBack,
    required this.isScheduledForFlip,
    required this.isFlipped,
    required this.isFlippable,
    required this.hasPair,
    required this.onTap,
    super.key,
  });

  PokemonCard copyWith(
      {bool? isScheduledForFlip,
      bool? isFlipped,
      bool? isFlippable,
      bool? hasPair}) {
    return PokemonCard(
      id: id,
      cardBack: cardBack,
      isScheduledForFlip: isScheduledForFlip ?? this.isScheduledForFlip,
      isFlipped: isFlipped ?? this.isFlipped,
      isFlippable: isFlippable ?? this.isFlippable,
      hasPair: hasPair ?? this.hasPair,
      onTap: onTap,
    );
  }

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        widget.onTap(widget.id),
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => widget != null
            ? Stack(children: [widget, ...list])
            : Stack(children: list),
        switchInCurve: Curves.linear,
        switchOutCurve: Curves.linear.flipped,
        child: !widget.isFlipped ? const CardFront() : widget.cardBack,
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: math.pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(!this.widget.isFlipped) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder
            ? math.min(rotateAnim.value, math.pi / 2)
            : rotateAnim.value;

        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (rotateAnim.isCompleted &&
              this.widget.isFlipped &&
              this.widget.isScheduledForFlip) {
            print('somghints');
            Provider.of<CardsModel>(context, listen: false).flipToBackDone();
          }
        });

        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}

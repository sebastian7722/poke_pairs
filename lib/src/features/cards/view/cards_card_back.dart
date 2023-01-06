import 'package:flutter/widgets.dart';

class CardFront extends StatelessWidget {
  const CardFront({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 34, 115, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Image(
        image: AssetImage('assets/images/card_back.jpg'),
      ),
    );
  }
}

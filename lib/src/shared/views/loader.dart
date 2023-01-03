import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    final loadingBaseTextStyle = Theme.of(context).textTheme.displaySmall!;
    final loadingTextStyle =
        loadingBaseTextStyle.merge(const TextStyle(color: Colors.white));

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Text(
            "Loading...",
            style: loadingTextStyle,
          ),
        ),
      ),
    );
  }
}

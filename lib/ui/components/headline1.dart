import 'package:flutter/material.dart';

class Headline1 extends StatelessWidget {
  const Headline1({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

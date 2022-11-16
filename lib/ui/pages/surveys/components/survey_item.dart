import 'package:flutter/material.dart';

class SurveyItem extends StatelessWidget {
  const SurveyItem({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            spreadRadius: 0,
            blurRadius: 2,
            color: Colors.black,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '26 ago 2020',
            style: textTheme.headline6,
          ),
          const SizedBox(height: 20),
          Text(
            'Pergunta',
            style: textTheme.headline5,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';

class SurveyItem extends StatelessWidget {
  const SurveyItem(
    this.viewModel, {
    super.key,
  });

  final SurveyViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:
            viewModel.didAnswer ? Colors.green.shade900 : Colors.red.shade900,
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
            viewModel.date,
            style: textTheme.headline6,
          ),
          const SizedBox(height: 20),
          Text(
            viewModel.question,
            style: textTheme.headline5,
          ),
        ],
      ),
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/components/spinner_dialog.dart';
import 'package:fordev/utils/i18n/i18n.dart';

import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key, required this.presenter});

  final SurveysPresenter presenter;

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  @override
  Widget build(BuildContext context) {
    widget.presenter.loadData();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          R.strings.surveys,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Builder(builder: (context) {
        widget.presenter.isLoadingController.listen(_isLoading);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 1,
              enlargeCenterPage: true,
            ),
            items: const [
              SurveyItem(),
              SurveyItem(),
              SurveyItem(),
            ],
          ),
        );
      }),
    );
  }

  void _isLoading(bool isLoading) {
    if (isLoading) {
      showLoading(context);
    } else {
      hidenLoading(context);
    }
  }
}

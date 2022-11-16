import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/components/spinner_dialog.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';
import 'package:fordev/utils/i18n/i18n.dart';

import 'components/components.dart';

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
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingController.listen(_isLoading);

          return StreamBuilder<List<SurveyViewModel>>(
            stream: widget.presenter.loadSurveysController,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  children: [
                    Text(
                      snapshot.error.toString(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: null,
                      child: Text(R.strings.reload),
                    ),
                  ],
                );
              }

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
            },
          );
        },
      ),
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

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/components/spinner_dialog.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';
import 'package:fordev/utils/i18n/i18n.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'components/components.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key, required this.presenter});

  final SurveysPresenter presenter;

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  @override
  void initState() {
    super.initState();

    widget.presenter.navigateToStream.listen((route) {
      if (route != null) {
        Get.toNamed(route);
      }
    });

    widget.presenter.isSessionExpiredStream.listen((sessionExpired) {
      if (sessionExpired == true) {
        Get.offAllNamed('/login');
      }
    });
  }

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
            stream: widget.presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  children: [
                    Text('${snapshot.error}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => widget.presenter.loadData(),
                      child: Text(R.strings.reload),
                    ),
                  ],
                );
              }

              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1,
                      enlargeCenterPage: true,
                    ),
                    items: snapshot.data!
                        .map(
                          (viewModel) => Provider(
                            create: (context) => widget.presenter,
                            child: SurveyItem(
                              viewModel,
                              key: Key(viewModel.id),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              }
              return Container();
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

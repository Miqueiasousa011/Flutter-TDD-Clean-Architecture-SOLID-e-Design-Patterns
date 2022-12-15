import 'package:flutter/material.dart';
import 'package:fordev/utils/i18n/i18n.dart';

import '../../components/components.dart';
import 'survey_result_presenter.dart';

class SurveyResultPage extends StatefulWidget {
  const SurveyResultPage({super.key, required this.presenter});

  final SurveyResultPresenter presenter;

  @override
  State<SurveyResultPage> createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.loadData();
  }

  void handleLoadingWidgetbool(isLoading) {
    if (isLoading) {
      showLoading(context);
    } else {
      hidenLoading(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(builder: (context) {
        widget.presenter.isLoadingController.listen(handleLoadingWidgetbool);

        return ListView.separated(
          padding: const EdgeInsets.only(top: 20),
          itemCount: 2,
          separatorBuilder: (context, index) =>
              index == 0 ? const SizedBox() : const Divider(),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Qual é o seu ola mundo?',
                  style: Theme.of(context).textTheme.headline6,
                ),
              );
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ract',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.grey[400],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fordev/ui/mixins/mixins.dart';
import 'package:fordev/utils/i18n/i18n.dart';

import 'survey_result_presenter.dart';
import 'survey_result_view_model.dart';

class SurveyResultPage extends StatefulWidget {
  const SurveyResultPage({super.key, required this.presenter});

  final SurveyResultPresenter presenter;

  @override
  State<SurveyResultPage> createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage>
    with LoadingManager, SessionManager {
  @override
  void initState() {
    super.initState();
    widget.presenter.loadData();

    handleSessionExpired(widget.presenter.isSessionExpiredStream);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleLoading(context, widget.presenter.isLoadingController);

          return StreamBuilder<SurveyResultViewModel>(
            stream: widget.presenter.surveyResultController,
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

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              final result = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        result.question,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    ...result.answers.map(
                      (answer) => InkWell(
                        onTap: () {
                          if (!answer.isCurrentAnswer) {
                            widget.presenter.save(answer: answer.answer);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (answer.image.isNotEmpty) ...[
                              Image.network(answer.image)
                            ],
                            Text(
                              answer.answer,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            answer.isCurrentAnswer
                                ? const ActiveIcon()
                                : const DisabledIcon(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DisabledIcon extends StatelessWidget {
  const DisabledIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle,
      color: Colors.grey[400],
    );
  }
}

class ActiveIcon extends StatelessWidget {
  const ActiveIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.check_circle,
      color: Colors.green,
    );
  }
}

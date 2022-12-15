class SurveyResultViewModel {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  SurveyResultViewModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });
}

class SurveyAnswerViewModel {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final String percent;

  SurveyAnswerViewModel({
    required this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });
}

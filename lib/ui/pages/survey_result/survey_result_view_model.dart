import 'package:equatable/equatable.dart';

class SurveyResultViewModel extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  const SurveyResultViewModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  @override
  List<Object> get props => [surveyId, question, answers];
}

class SurveyAnswerViewModel extends Equatable {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final String percent;

  const SurveyAnswerViewModel({
    required this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });

  @override
  List<Object?> get props => [image, answer, isCurrentAnswer, percent];
}

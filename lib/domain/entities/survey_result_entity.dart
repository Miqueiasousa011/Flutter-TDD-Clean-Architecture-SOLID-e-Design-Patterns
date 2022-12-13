import 'survey_answer_entity.dart';

class SurveyResultEntity {
  final String surveyId;
  final String question;
  final bool didAnswer;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    required this.surveyId,
    required this.question,
    required this.didAnswer,
    required this.answers,
  });
}

import '../../domain/entities/entities.dart';
import '../../ui/pages/survey_result/survey_result.dart';

extension SurveyAnswerEntityExtension on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() => SurveyAnswerViewModel(
        answer: answer,
        percent: '$percent%',
        image: image ?? '',
        isCurrentAnswer: isCurrentAnswer,
      );
}

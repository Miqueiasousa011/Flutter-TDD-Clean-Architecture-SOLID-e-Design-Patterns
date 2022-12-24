import 'package:fordev/ui/pages/survey_result/survey_result.dart';

import '../../domain/entities/entities.dart';
import './survey_answer_entity_extension.dart';

extension SurveyResultEntityExtension on SurveyResultEntity {
  SurveyResultViewModel toViewModel() => SurveyResultViewModel(
        surveyId: surveyId,
        question: question,
        answers: answers.map((e) => e.toViewModel()).toList(),
      );
}

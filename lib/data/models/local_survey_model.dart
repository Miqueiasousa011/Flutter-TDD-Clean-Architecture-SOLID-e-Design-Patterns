import 'package:fordev/domain/entities/survey_entity.dart';

class LocalSurveyModel {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  LocalSurveyModel({
    required this.id,
    required this.question,
    required this.date,
    required this.didAnswer,
  });

  factory LocalSurveyModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys
        .toSet()
        .containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw Exception();
    }

    return LocalSurveyModel(
      id: json['id'],
      question: json['question'],
      date: json['date'],
      didAnswer: json['didAnswer'],
    );
  }

  factory LocalSurveyModel.fromEntity(SurveyEntity survey) {
    return LocalSurveyModel(
      id: survey.id,
      question: survey.question,
      date: survey.dateTime.toIso8601String(),
      didAnswer: survey.didAnswer,
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        dateTime: DateTime.parse(date),
        didAnswer: didAnswer,
      );

  Map<String, String> toMap() => {
        'id': id,
        'question': question,
        'date': date,
        'didAnswer': didAnswer.toString(),
      };
}

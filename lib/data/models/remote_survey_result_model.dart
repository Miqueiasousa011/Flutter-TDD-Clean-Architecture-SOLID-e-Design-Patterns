import 'package:fordev/data/http/http_error.dart';

import '../../domain/entities/entities.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerModel> answers;

  RemoteSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  factory RemoteSurveyResultModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw HttpError.invalidData;
    }

    final answers = <RemoteSurveyAnswerModel>[];
    for (var answer in json['answers']) {
      answers.add(RemoteSurveyAnswerModel.fromJson(answer));
    }

    return RemoteSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: answers,
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers.map((answer) => answer.toEntity()).toList(),
      );
}

class RemoteSurveyAnswerModel {
  final String? image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  RemoteSurveyAnswerModel({
    this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });

  factory RemoteSurveyAnswerModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys.toSet().containsAll(
        ['image', 'answer', 'isCurrentAccountAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAnswer: json['isCurrentAccountAnswer'],
      percent: json['percent'],
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: percent,
      );
}

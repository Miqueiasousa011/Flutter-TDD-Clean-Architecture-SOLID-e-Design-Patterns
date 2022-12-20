import 'package:fordev/domain/entities/entities.dart';

class LocalSurveyResultModel {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  factory LocalSurveyResultModel.fromMap(Map<String, dynamic> map) {
    if (!map.keys.toSet().containsAll(['answers', 'question', 'surveyId'])) {
      throw Exception();
    }
    return LocalSurveyResultModel(
      answers: map['answers']
          .map<LocalSurveyAnswerModel>(
              (answer) => LocalSurveyAnswerModel.fromMap(answer))
          .toList(),
      question: map['question'],
      surveyId: map['surveyId'],
    );
  }

  factory LocalSurveyResultModel.fromEntity(SurveyResultEntity entity) {
    return LocalSurveyResultModel(
      surveyId: entity.surveyId,
      question: entity.question,
      answers: entity.answers
          .map<LocalSurveyAnswerModel>(
              (e) => LocalSurveyAnswerModel.fromEntity(e))
          .toList(),
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers
            .map<SurveyAnswerEntity>((answer) => answer.toEntity())
            .toList(),
      );

  Map<String, dynamic> toMap() {
    return {
      'surveyId': surveyId,
      'question': question,
      'answers': answers.map((e) => e.toMap()).toList(),
    };
  }
}

class LocalSurveyAnswerModel {
  final String? image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  LocalSurveyAnswerModel({
    this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });

  factory LocalSurveyAnswerModel.fromMap(Map<String, dynamic> map) {
    if (!map.keys.toSet().containsAll(
        ['image', 'answer', 'isCurrentAccountAnswer', 'percent'])) {
      throw Exception();
    }

    return LocalSurveyAnswerModel(
      image: map['image'],
      answer: map['answer'],
      isCurrentAnswer: map['isCurrentAccountAnswer'] == 'true' ? true : false,
      percent: int.parse(map['percent']),
    );
  }

  factory LocalSurveyAnswerModel.fromEntity(SurveyAnswerEntity entity) {
    return LocalSurveyAnswerModel(
      image: entity.image,
      answer: entity.answer,
      isCurrentAnswer: entity.isCurrentAnswer,
      percent: entity.percent,
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: percent,
      );

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'answer': answer,
      'isCurrentAccountAnswer': isCurrentAnswer.toString(),
      'percent': percent.toString(),
    };
  }
}

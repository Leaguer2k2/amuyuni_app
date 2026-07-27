enum QuestionType { iaVsReal, multipleChoice, whatsappSimulator, sliderAnalysis }

class QuestionModel {
  final String id;
  final QuestionType type;
  final String question;
  final String? imageUrl;
  final List<String> options;
  final int correctAnswer;
  final String feedbackCorrect;
  final String feedbackWrong;
  final String lupaHint;
  final String? audioPrompt;

  const QuestionModel({
    required this.id,
    required this.type,
    required this.question,
    this.imageUrl,
    required this.options,
    required this.correctAnswer,
    required this.feedbackCorrect,
    required this.feedbackWrong,
    required this.lupaHint,
    this.audioPrompt,
  });
}

class AylluChallengeModel {
  final String id;
  final String title;
  final String description;
  final String role;
  final int rewardPoints;
  bool completed;

  AylluChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.role,
    required this.rewardPoints,
    this.completed = false,
  });
}

class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  bool unlocked;
  final int progressTotal;
  int progressCurrent;

  BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.unlocked = false,
    required this.progressTotal,
    this.progressCurrent = 0,
  });

  double get progress => progressTotal > 0 ? (progressCurrent / progressTotal).clamp(0.0, 1.0) : 0.0;
}

class WhatsAppScenario {
  final String id;
  final String title;
  final String scammerName;
  final String initialMessage;
  final String optionAText;
  final String optionBText;
  final String feedbackA;
  final String feedbackB;
  final bool optionBIsCorrect;

  const WhatsAppScenario({
    required this.id,
    required this.title,
    required this.scammerName,
    required this.initialMessage,
    required this.optionAText,
    required this.optionBText,
    required this.feedbackA,
    required this.feedbackB,
    this.optionBIsCorrect = true,
  });
}

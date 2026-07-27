import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/question_banks.dart';
import '../data/ayllu_data.dart';

class GameState extends ChangeNotifier {
  int _streakDays = 5;
  final int _lives = 3;
  final int _maxLives = 3;
  int _points = 120;

  int _unlockedNodes = 2;

  final Map<int, int> _nodeProgress = {0: 0, 1: 0, 2: 0, 3: 0};
  final Map<int, int> _nodeCorrect = {0: 0, 1: 0, 2: 0, 3: 0};

  final List<AylluChallengeModel> _challenges =
      List.from(aylluChallenges.map((c) => AylluChallengeModel(
            id: c['id'] as String,
            title: c['title'] as String,
            description: c['description'] as String,
            role: c['role'] as String,
            rewardPoints: c['rewardPoints'] as int,
          )));

  final List<BadgeModel> _badges = List.from(defaultBadges.map((b) => BadgeModel(
        id: b['id'] as String,
        name: b['name'] as String,
        description: b['description'] as String,
        icon: b['icon'] as String,
        progressTotal: b['progressTotal'] as int,
      )));

  final List<String> _testimonials = List.from(defaultTestimonials);
  int _communityLessons = 8400;

  int get streakDays => _streakDays;
  int get lives => _lives;
  int get maxLives => _maxLives;
  int get points => _points;
  int get unlockedNodes => _unlockedNodes;
  int get communityLessons => _communityLessons;
  double get communityProgress => _communityLessons / 10000.0;

  List<AylluChallengeModel> get challenges => _challenges;
  List<BadgeModel> get badges => _badges;
  List<String> get testimonials => _testimonials;

  int getNodeProgress(int nodeIndex) => _nodeProgress[nodeIndex] ?? 0;
  int getNodeCorrect(int nodeIndex) => _nodeCorrect[nodeIndex] ?? 0;
  bool isNodeUnlocked(int nodeIndex) => nodeIndex < _unlockedNodes;

  QuestionModel? getQuestion(int nodeIndex, int questionIndex) {
    final bank = allQuestionBanks[nodeIndex];
    if (questionIndex < bank.length) {
      return bank[questionIndex];
    }
    return null;
  }

  int getQuestionsCount(int nodeIndex) {
    final bank = allQuestionBanks[nodeIndex];
    return bank.length;
  }

  WhatsAppScenario? getWhatsAppScenario(int questionIndex) {
    if (questionIndex < whatsAppScenarios.length) {
      return whatsAppScenarios[questionIndex];
    }
    return null;
  }

  void submitAnswer(int nodeIndex, bool isCorrect) {
    _nodeProgress[nodeIndex] = (_nodeProgress[nodeIndex] ?? 0) + 1;
    if (isCorrect) {
      _nodeCorrect[nodeIndex] = (_nodeCorrect[nodeIndex] ?? 0) + 1;
      _points += 10;
    }

    final totalInNode = allQuestionBanks[nodeIndex].length;
    if (_nodeProgress[nodeIndex]! >= totalInNode) {
      if (nodeIndex + 1 > _unlockedNodes) {
        _unlockedNodes = nodeIndex + 1;
      }
      _points += 30;
      _updateBadges(nodeIndex);
    }

    _streakDays = _streakDays + 1;
    notifyListeners();
  }

  void _updateBadges(int nodeIndex) {
    for (final badge in _badges) {
      if (badge.id == 'guardian_digital' && !badge.unlocked) {
        badge.progressCurrent = _unlockedNodes;
        if (_unlockedNodes >= badge.progressTotal) {
          badge.unlocked = true;
        }
      }
      if (badge.id == 'ojo_tiwula' && !badge.unlocked) {
        int totalCorrect = 0;
        for (int i = 0; i <= nodeIndex; i++) {
          totalCorrect += _nodeCorrect[i] ?? 0;
        }
        badge.progressCurrent = totalCorrect;
        if (badge.progressCurrent >= badge.progressTotal) {
          badge.unlocked = true;
        }
      }
      if (badge.id == 'maestro_radar' && !badge.unlocked) {
        badge.progressCurrent = _communityLessons ~/ 1000;
        if (badge.progressCurrent >= badge.progressTotal) {
          badge.unlocked = true;
        }
      }
    }
  }

  void completeChallenge(int index) {
    if (index < _challenges.length && !_challenges[index].completed) {
      _challenges[index].completed = true;
      _points += _challenges[index].rewardPoints;
      _communityLessons += 1;

      final badge = _badges.firstWhere(
        (b) => b.id == 'ayllu_protector',
        orElse: () => _badges[3],
      );
      if (!badge.unlocked) {
        badge.progressCurrent =
            _challenges.where((c) => c.completed).length;
        if (badge.progressCurrent >= badge.progressTotal) {
          badge.unlocked = true;
        }
      }

      notifyListeners();
    }
  }

  void addTestimonial(String text) {
    _testimonials.insert(0, text);
    notifyListeners();
  }

  void checkLink(String link) {
    _communityLessons += 1;
    final badge = _badges.firstWhere(
      (b) => b.id == 'maestro_radar',
      orElse: () => _badges[3],
    );
    if (!badge.unlocked) {
      badge.progressCurrent = _communityLessons ~/ 1000;
      if (badge.progressCurrent >= badge.progressTotal) {
        badge.unlocked = true;
      }
    }
    notifyListeners();
  }
}

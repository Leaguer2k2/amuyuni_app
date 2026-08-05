import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';
import '../services/game_state.dart';
import '../theme/andean_theme.dart';
import '../widgets/andean_widgets.dart';

class LessonScreen extends StatefulWidget {
  final int nodeIndex;

  const LessonScreen({super.key, required this.nodeIndex});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int currentIndex = 0;
  int? selectedOptionIndex;
  bool isAnswered = false;
  bool isLessonCompleted = false;

  late GameState _game;
  late List<int> _questionOrder;
  List<String> _shuffledOptions = [];
  int _correctShuffledIndex = 0;

  QuestionModel get _question => _game.getQuestion(widget.nodeIndex, _questionOrder[currentIndex])!;
  int get _totalQuestions => _questionOrder.length;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _game = ChangeNotifierProvider.read(context);
    _initQuestionOrder();
    _prepareQuestion();
  }

  void _initQuestionOrder() {
    final total = _game.getQuestionsCount(widget.nodeIndex);
    _questionOrder = List.generate(total, (i) => i)..shuffle();
  }

  void _prepareQuestion() {
    final q = _question;
    final indexed = q.options.asMap().entries.toList()..shuffle();
    _shuffledOptions = indexed.map((e) => e.value).toList();
    _correctShuffledIndex = indexed.indexWhere((e) => e.key == q.correctAnswer);
  }

  void _selectOption(int option) {
    if (isAnswered || !mounted) return;
    setState(() => selectedOptionIndex = option);
  }

  void _checkAnswer() {
    if (selectedOptionIndex == null || isAnswered || !mounted) return;
    final isCorrect = selectedOptionIndex == _correctShuffledIndex;
    _game.submitAnswer(widget.nodeIndex, isCorrect);
    setState(() => isAnswered = true);
  }

  void _continueAction() {
    if (!mounted) return;
    if (currentIndex + 1 < _totalQuestions) {
      setState(() {
        currentIndex++;
        selectedOptionIndex = null;
        isAnswered = false;
      });
      _prepareQuestion();
    } else {
      setState(() => isLessonCompleted = true);
    }
  }

  void _returnToHome() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!context.mounted) return;
    final nav = Navigator.of(context);
    Future.microtask(() {
      if (context.mounted) {
        nav.pop();
      }
    });
  }

  String get _nodeTitle {
    switch (widget.nodeIndex) {
      case 0:
        return 'Phishing y QR Falsos';
      case 1:
        return 'IA vs Realidad';
      case 2:
        return 'Simulador WhatsApp';
      case 3:
        return 'Fake News y Emociones';
      default:
        return 'Reto';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLessonCompleted) {
      return Scaffold(
        body: ResponsiveWrapper(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AndeanColors.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: AndeanColors.glowShadowOrange,
                    ),
                    child: const Text('🦊🏆', style: TextStyle(fontSize: 56)),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.nodeIndex == 3 ? '¡COMPLETASTE TODA LA RUTA!' : '¡Nodo Completado!',
                    style: AndeanTextStyles.headerMedium.copyWith(fontSize: 22, color: AndeanColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_game.getNodeCorrect(widget.nodeIndex)} / $_totalQuestions respuestas correctas',
                    style: AndeanTextStyles.headerSmall,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AndeanColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '+${_game.getNodeCorrect(widget.nodeIndex) * 10 + 30} Puntos Chaski ganados 🪙',
                      style: AndeanTextStyles.statNumber.copyWith(color: AndeanColors.success),
                    ),
                  ),
                  if (widget.nodeIndex + 1 < 4) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: AndeanColors.headerGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('🔓 Nodo ${widget.nodeIndex + 2} desbloqueado',
                          style: AndeanTextStyles.buttonText.copyWith(fontSize: 14)),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'Tiwula está orgulloso de ti.\nCada lección protege a tu comunidad.',
                    textAlign: TextAlign.center,
                    style: AndeanTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: AndeanGameButton(
                      text: 'VOLVER AL MAPA',
                      icon: Icons.home_rounded,
                      color: AndeanColors.secondary,
                      onPressed: _returnToHome,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final question = _question;
    final progress = (currentIndex + 1) / _totalQuestions;
    final isCorrect = isAnswered && selectedOptionIndex == _correctShuffledIndex;

    return Scaffold(
      body: ResponsiveWrapper(
        child: Column(
          children: [
            _LessonHeader(
              title: _nodeTitle,
              subtitle: '${currentIndex + 1} de $_totalQuestions retos',
              progress: progress,
              onBack: _returnToHome,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ValueKey('q_$currentIndex'),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _QuestionCard(key: ValueKey(question.id), question: question, nodeIndex: widget.nodeIndex),
                    const SizedBox(height: 16),
                    if (question.type == QuestionType.sliderAnalysis)
                      _ImageComparisonCards(
                        question: question,
                        isSelectedA: selectedOptionIndex == 0,
                        isSelectedB: selectedOptionIndex == 1,
                        showFeedback: isAnswered,
                        correctAnswer: _correctShuffledIndex,
                        enabled: !isAnswered,
                        onTapA: () => _selectOption(0),
                        onTapB: () => _selectOption(1),
                      )
                    else if (question.type == QuestionType.iaVsReal ||
                        question.imageUrl != null)
                      _ImageCard(
                        imageUrl: question.imageUrl,
                        lupaHint: question.lupaHint,
                        isCorrect: selectedOptionIndex == _correctShuffledIndex,
                        showOverlay: selectedOptionIndex != null,
                      ),
                    const SizedBox(height: 16),
                    ..._shuffledOptions.asMap().entries.map(
                          (e) => _OptionCard(
                            index: e.key,
                            title: e.value,
                            isSelected: selectedOptionIndex == e.key,
                            showCorrect: isAnswered && e.key == _correctShuffledIndex,
                            showWrong: isAnswered && selectedOptionIndex == e.key &&
                                e.key != _correctShuffledIndex,
                            enabled: !isAnswered,
                            onTap: () => _selectOption(e.key),
                          ),
                        ),
                    const SizedBox(height: 16),
                    if (isAnswered) _FeedbackBlock(isCorrect: isCorrect, question: question),
                  ],
                ),
              ),
            ),
            _BottomBar(
              isAnswered: isAnswered,
              selectedOptionIndex: selectedOptionIndex,
              isLastQuestion: currentIndex + 1 >= _totalQuestions,
              onCheck: _checkAnswer,
              onContinue: _continueAction,
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final VoidCallback onBack;

  const _LessonHeader({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AndeanColors.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: AndeanTextStyles.headerMedium.copyWith(color: Colors.white, fontSize: 18)),
                        Text(subtitle,
                            style: AndeanTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AndeanProgressBar(
                value: progress,
                height: 10,
                gradientColors: [AndeanColors.gold, AndeanColors.primary],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int nodeIndex;

  const _QuestionCard({super.key, required this.question, required this.nodeIndex});

  @override
  Widget build(BuildContext context) {
    return AndeanCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AndeanColors.goldGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.quiz, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(child: Text('RETO', style: AndeanTextStyles.label)),
              AndeanChip(label: 'Nodo ${nodeIndex + 1}', color: AndeanColors.secondary),
            ],
          ),
          const SizedBox(height: 14),
          Text(question.question, style: AndeanTextStyles.headerSmall.copyWith(fontSize: 15)),
        ],
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String? imageUrl;
  final String lupaHint;
  final bool isCorrect;
  final bool showOverlay;

  const _ImageCard({
    this.imageUrl,
    required this.lupaHint,
    required this.isCorrect,
    required this.showOverlay,
  });

  static const _fallbackUrls = [
    'https://images.unsplash.com/photo-1635365626712-5c6d125a6cc2?w=600&h=400&fit=crop',
    'https://images.unsplash.com/photo-1517299321609-52687d1bc55a?w=600&h=400&fit=crop',
    'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=600&h=400&fit=crop',
    'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&h=400&fit=crop',
    'https://images.unsplash.com/photo-1504711434969-e33886168d6c?w=600&h=400&fit=crop',
    'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=600&h=400&fit=crop',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AndeanCard(
        padding: EdgeInsets.zero,
        borderRadius: 24,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl ?? _fallbackUrls[0],
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) {
                    final seed = (lupaHint.hashCode % _fallbackUrls.length).abs();
                    return Image.network(
                      _fallbackUrls[seed],
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AndeanColors.background,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.image_search, size: 40, color: AndeanColors.greyCool),
                                const SizedBox(height: 8),
                                Text('🔍 $lupaHint', textAlign: TextAlign.center,
                                    style: AndeanTextStyles.bodySmall),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AndeanColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AndeanColors.buttonShadow,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text('Lupa del Zorro',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                if (showOverlay)
                  Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: isCorrect ? AndeanColors.success : AndeanColors.redAlert,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AndeanColors.buttonShadow,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: Colors.white, size: 24),
                            const SizedBox(width: 8),
                            Text(isCorrect ? '¡Correcto!' : 'Incorrecto',
                                style: AndeanTextStyles.buttonText.copyWith(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageComparisonCards extends StatelessWidget {
  final QuestionModel question;
  final bool isSelectedA;
  final bool isSelectedB;
  final bool showFeedback;
  final int correctAnswer;
  final bool enabled;
  final VoidCallback onTapA;
  final VoidCallback onTapB;

  const _ImageComparisonCards({
    required this.question,
    required this.isSelectedA,
    required this.isSelectedB,
    required this.showFeedback,
    required this.correctAnswer,
    required this.enabled,
    required this.onTapA,
    required this.onTapB,
  });

  static const _fallbackUrls = [
    'https://images.unsplash.com/photo-1635365626712-5c6d125a6cc2?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1517299321609-52687d1bc55a?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1504711434969-e33886168d6c?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=400&h=300&fit=crop',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AndeanColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AndeanColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.compare, color: AndeanColors.accent, size: 16),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('¿Cuál imagen fue generada por IA?',
                    style: AndeanTextStyles.bodySmall),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                label: 'A', title: question.options[0],
                isSelected: isSelectedA,
                showAsCorrect: showFeedback && correctAnswer == 0,
                showAsWrong: showFeedback && isSelectedA && correctAnswer != 0,
                enabled: enabled, onTap: onTapA, imageSeed: 0,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCard(
                label: 'B', title: question.options[1],
                isSelected: isSelectedB,
                showAsCorrect: showFeedback && correctAnswer == 1,
                showAsWrong: showFeedback && isSelectedB && correctAnswer != 1,
                enabled: enabled, onTap: onTapB, imageSeed: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({
    required String label,
    required String title,
    required bool isSelected,
    required bool showAsCorrect,
    required bool showAsWrong,
    required bool enabled,
    required VoidCallback onTap,
    required int imageSeed,
  }) {
    Color borderC;
    Color overlayC;

    if (showAsCorrect) {
      borderC = AndeanColors.success;
      overlayC = AndeanColors.success.withValues(alpha: 0.25);
    } else if (showAsWrong) {
      borderC = AndeanColors.redAlert;
      overlayC = AndeanColors.redAlert.withValues(alpha: 0.25);
    } else if (isSelected) {
      borderC = AndeanColors.primary;
      overlayC = Colors.transparent;
    } else {
      borderC = Colors.grey.shade300;
      overlayC = Colors.transparent;
    }

    final url = question.imageUrl ?? _fallbackUrls[(imageSeed) % _fallbackUrls.length];

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderC, width: 2),
          boxShadow: (isSelected || showAsCorrect || showAsWrong)
              ? [BoxShadow(color: borderC.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AndeanColors.background,
                          child: const Center(child: Icon(Icons.image, size: 32, color: AndeanColors.greyCool)),
                        );
                      },
                    ),
                  ),
                  if (showAsCorrect || showAsWrong)
                    Positioned.fill(
                      child: Container(
                        color: overlayC,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: showAsCorrect ? AndeanColors.success : AndeanColors.redAlert,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(showAsCorrect ? Icons.check : Icons.close, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ),
                  if (isSelected && !showAsCorrect && !showAsWrong)
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AndeanColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 14),
                      ),
                    ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: (isSelected || showAsCorrect || showAsWrong) ? borderC.withValues(alpha: 0.1) : Colors.grey.shade50,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: borderC.withValues(alpha: 0.15),
                        border: Border.all(color: borderC, width: 1.5),
                      ),
                      child: Center(child: Text(label,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: borderC))),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(title,
                          style: TextStyle(fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? borderC : AndeanColors.textDark),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final int index;
  final String title;
  final bool isSelected;
  final bool showCorrect;
  final bool showWrong;
  final bool enabled;
  final VoidCallback onTap;

  const _OptionCard({
    required this.index,
    required this.title,
    required this.isSelected,
    required this.showCorrect,
    required this.showWrong,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color borderC;
    final Widget? trailing;

    if (showCorrect) {
      bg = AndeanColors.success.withValues(alpha: 0.08);
      borderC = AndeanColors.success;
      trailing = const Icon(Icons.check_circle, color: AndeanColors.success);
    } else if (showWrong) {
      bg = AndeanColors.redAlert.withValues(alpha: 0.08);
      borderC = AndeanColors.redAlert;
      trailing = const Icon(Icons.cancel, color: AndeanColors.redAlert);
    } else if (isSelected) {
      bg = AndeanColors.primary.withValues(alpha: 0.06);
      borderC = AndeanColors.primary;
      trailing = null;
    } else {
      bg = Colors.white;
      borderC = Colors.grey.shade200;
      trailing = null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderC, width: 2),
            boxShadow: (isSelected || showCorrect) ? AndeanColors.glowShadowOrange : [],
          ),
          child: Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isSelected || showCorrect || showWrong)
                      ? borderC.withValues(alpha: 0.15)
                      : Colors.grey.shade100,
                  border: Border.all(color: borderC.withValues(alpha: 0.4), width: 2),
                ),
                child: Center(
                  child: Text(String.fromCharCode(65 + index),
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: borderC)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title,
                    style: AndeanTextStyles.body.copyWith(
                        fontWeight: (isSelected || showCorrect) ? FontWeight.w700 : FontWeight.w500)),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackBlock extends StatelessWidget {
  final bool isCorrect;
  final QuestionModel question;

  const _FeedbackBlock({required this.isCorrect, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect ? AndeanColors.success.withValues(alpha: 0.06) : AndeanColors.redAlert.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCorrect ? AndeanColors.success.withValues(alpha: 0.25) : AndeanColors.redAlert.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: isCorrect ? AndeanColors.successGradient
                      : const LinearGradient(colors: [AndeanColors.redAlert, AndeanColors.orangeAlert]),
                  shape: BoxShape.circle,
                  boxShadow: AndeanColors.buttonShadow,
                ),
                child: Text(isCorrect ? '🎉' : '💡', style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isCorrect ? '¡Excelente!' : '¡Casi lo logras!',
                        style: AndeanTextStyles.headerSmall.copyWith(fontSize: 16)),
                    if (isCorrect)
                      Text('+10 pts 🪙',
                          style: AndeanTextStyles.body.copyWith(
                              color: AndeanColors.success, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AndeanColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🔍', style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text('Lupa del Zorro:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AndeanColors.secondary)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(question.lupaHint, style: AndeanTextStyles.body.copyWith(fontSize: 13)),
          const SizedBox(height: 8),
          Text(isCorrect ? question.feedbackCorrect : question.feedbackWrong, style: AndeanTextStyles.body),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool isAnswered;
  final int? selectedOptionIndex;
  final bool isLastQuestion;
  final VoidCallback onCheck;
  final VoidCallback onContinue;

  const _BottomBar({
    required this.isAnswered,
    required this.selectedOptionIndex,
    required this.isLastQuestion,
    required this.onCheck,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -3))],
      ),
      child: SafeArea(
        top: false,
        child: isAnswered
            ? AndeanGameButton(
                text: isLastQuestion ? 'VOLVER AL INICIO' : 'CONTINUAR',
                icon: isLastQuestion ? Icons.home : Icons.arrow_forward,
                color: isLastQuestion ? AndeanColors.secondary : AndeanColors.success,
                onPressed: onContinue,
              )
            : AndeanGameButton(
                text: 'COMPROBAR RESPUESTA',
                icon: Icons.search,
                onPressed: selectedOptionIndex == null ? null : onCheck,
              ),
      ),
    );
  }
}

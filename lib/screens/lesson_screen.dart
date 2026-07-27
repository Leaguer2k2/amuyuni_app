import 'package:flutter/material.dart';
import 'dart:math' as math;
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
  int _questionIndex = 0;
  int? _selectedOption;
  double _sliderValue = 0.5;
  bool _audioActive = false;
  bool _feedbackShown = false;

  late GameState _game;
  QuestionModel get _question => _game.getQuestion(widget.nodeIndex, _questionIndex)!;
  int get _totalQuestions => _game.getQuestionsCount(widget.nodeIndex);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _game = ChangeNotifierProvider.of(context);
  }

  void _onAnswer(int option) {
    if (_feedbackShown) return;
    setState(() => _selectedOption = option);
  }

  void _checkAnswer() {
    if (_selectedOption == null || _feedbackShown) return;
    final isCorrect = _selectedOption == _question.correctAnswer;
    _game.submitAnswer(widget.nodeIndex, isCorrect);
    setState(() => _feedbackShown = true);
    _showFeedback(isCorrect);
  }

  void _showFeedback(bool isCorrect) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FeedbackSheet(
        isCorrect: isCorrect,
        question: _question,
        onContinue: () {
          Navigator.pop(ctx);
          if (_questionIndex + 1 < _totalQuestions) {
            setState(() {
              _questionIndex++;
              _selectedOption = null;
              _sliderValue = 0.5;
              _feedbackShown = false;
            });
          } else {
            _showCompletionScreen();
          }
        },
        onAudio: () {
          setState(() => _audioActive = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🔊 ${_question.audioPrompt ?? "Tiwula explica..."}'),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }

  void _showCompletionScreen() {
    final correct = _game.getNodeCorrect(widget.nodeIndex);
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CompletionDialog(
        nodeIndex: widget.nodeIndex,
        correct: correct,
        total: _totalQuestions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _question;
    final progress = (_questionIndex + 1) / _totalQuestions;

    return Scaffold(
      body: ResponsiveWrapper(
        child: Column(
          children: [
            _buildHeader(progress),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildQuestionCard(question),
                    const SizedBox(height: 16),
                    if (question.type == QuestionType.sliderAnalysis ||
                        question.type == QuestionType.iaVsReal ||
                        question.imageUrl != null)
                      _buildImageCard(question),
                    if (question.type == QuestionType.sliderAnalysis)
                      _buildSliderCard(question),
                    const SizedBox(height: 16),
                    ...question.options.asMap().entries.map((e) =>
                        _buildOptionTile(e.key, e.value)),
                    const SizedBox(height: 20),
                    if (!_feedbackShown)
                      AndeanGameButton(
                        text: 'COMPROBAR RESPUESTA',
                        onPressed: _selectedOption == null ? null : _checkAnswer,
                        icon: Icons.search,
                      )
                    else
                      AndeanGameButton(
                        text: _questionIndex + 1 < _totalQuestions
                            ? 'SIGUIENTE (${_questionIndex + 1}/$_totalQuestions)'
                            : 'VER RESULTADOS',
                        onPressed: () {
                          if (_questionIndex + 1 < _totalQuestions) {
                            setState(() {
                              _questionIndex++;
                              _selectedOption = null;
                              _sliderValue = 0.5;
                              _feedbackShown = false;
                            });
                          } else {
                            _showCompletionScreen();
                          }
                        },
                        color: AndeanColors.success,
                        icon: Icons.arrow_forward,
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double progress) {
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
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getNodeTitle(),
                          style: AndeanTextStyles.headerMedium.copyWith(
                              color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          '${_questionIndex + 1} de $_totalQuestions retos',
                          style: AndeanTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _audioActive ? Icons.volume_up : Icons.volume_up_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() => _audioActive = !_audioActive);
                      if (_audioActive) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🔊 ${_question.audioPrompt ?? "Audio activado"}'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      }
                    },
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

  String _getNodeTitle() {
    switch (widget.nodeIndex) {
      case 0: return 'Phishing y QR Falsos';
      case 1: return 'IA vs Realidad';
      case 2: return 'Simulador WhatsApp';
      case 3: return 'Fake News y Emociones';
      default: return 'Reto';
    }
  }

  Widget _buildQuestionCard(QuestionModel q) {
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
              const Expanded(
                child: Text('RETO', style: AndeanTextStyles.label),
              ),
              AndeanChip(
                label: 'Nodo ${widget.nodeIndex + 1}',
                color: AndeanColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(q.question, style: AndeanTextStyles.headerSmall.copyWith(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildImageCard(QuestionModel q) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AndeanCard(
        padding: EdgeInsets.zero,
        borderRadius: 24,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: q.imageUrl != null
                    ? Image.network(q.imageUrl!, fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => _imagePlaceholder(q))
                    : _imagePlaceholder(q),
              ),
              Positioned(
                bottom: 12,
                right: 12,
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
              if (_selectedOption != null)
                Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: _selectedOption == q.correctAnswer
                            ? AndeanColors.success
                            : AndeanColors.redAlert,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AndeanColors.buttonShadow,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _selectedOption == q.correctAnswer
                                ? Icons.check_circle : Icons.cancel,
                            color: Colors.white, size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedOption == q.correctAnswer ? '¡Correcto!' : 'Incorrecto',
                            style: AndeanTextStyles.buttonText.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder(QuestionModel q) {
    return Container(
      color: AndeanColors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image_search, size: 40, color: AndeanColors.greyCool),
            const SizedBox(height: 8),
            Text('🔍 ${q.lupaHint}',
                textAlign: TextAlign.center,
                style: AndeanTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard(QuestionModel q) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AndeanCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AndeanColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.compare, color: AndeanColors.accent, size: 18),
                ),
                const SizedBox(width: 8),
                const Text('Comparador IA', style: AndeanTextStyles.headerSmall),
                const Spacer(),
                Text('${(_sliderValue * 100).round()}%',
                    style: AndeanTextStyles.statNumber.copyWith(color: AndeanColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 80,
                child: Stack(
                  children: [
                    Container(color: AndeanColors.background),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AndeanColors.secondary.withValues(alpha: 0.3),
                              AndeanColors.primary.withValues(alpha: 0.15),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text('${q.options[0]}  ←  →  ${q.options[1]}',
                              style: AndeanTextStyles.bodySmall.copyWith(fontSize: 11)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0, top: 0, bottom: 0,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: _sliderValue,
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AndeanColors.primary.withValues(alpha: 0.3),
                                  AndeanColors.redAlert.withValues(alpha: 0.2),
                                ],
                              ),
                              border: Border.all(color: AndeanColors.primary, width: 2),
                            ),
                            child: const Center(
                              child: Text('🤖 Zona IA',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                                      color: AndeanColors.primary)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: math.max(0, (_sliderValue * (MediaQuery.of(context).size.width - 72)) - 24),
                      top: 0, bottom: 0,
                      child: Container(width: 3, color: AndeanColors.primary),
                    ),
                  ],
                ),
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AndeanColors.primary,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: AndeanColors.primary,
                overlayColor: AndeanColors.primary.withValues(alpha: 0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              ),
              child: Slider(
                value: _sliderValue,
                onChanged: (v) => setState(() => _sliderValue = v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(int index, String title) {
    final isSelected = _selectedOption == index;
    final showCorrect = _feedbackShown && index == _question.correctAnswer;
    final showWrong = _feedbackShown && _selectedOption == index && !showCorrect;

    Color bg;
    Color borderC;
    Widget? trailing;

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
    } else {
      bg = Colors.white;
      borderC = Colors.grey.shade200;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: _feedbackShown ? null : () => _onAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderC,
              width: (isSelected || showCorrect || showWrong) ? 2.5 : 1.5,
            ),
            boxShadow: (isSelected || showCorrect)
                ? AndeanColors.glowShadowOrange
                : [],
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
                      style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 13,
                        color: borderC,
                      )),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title, style: AndeanTextStyles.body.copyWith(
                  fontWeight: (isSelected || showCorrect) ? FontWeight.w700 : FontWeight.w500,
                )),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackSheet extends StatelessWidget {
  final bool isCorrect;
  final QuestionModel question;
  final VoidCallback onContinue;
  final VoidCallback onAudio;

  const _FeedbackSheet({
    required this.isCorrect,
    required this.question,
    required this.onContinue,
    required this.onAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isCorrect
              ? [AndeanColors.success.withValues(alpha: 0.15), AndeanColors.success.withValues(alpha: 0.02)]
              : [AndeanColors.redAlert.withValues(alpha: 0.15), AndeanColors.redAlert.withValues(alpha: 0.02)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        color: Colors.white,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: isCorrect ? AndeanColors.successGradient : const LinearGradient(
                          colors: [AndeanColors.redAlert, AndeanColors.orangeAlert]),
                      shape: BoxShape.circle,
                      boxShadow: AndeanColors.buttonShadow,
                    ),
                    child: Text(isCorrect ? '🎉' : '💡', style: const TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCorrect ? '¡Excelente Trabajo!' : '¡Casi lo logras!',
                          style: AndeanTextStyles.headerMedium.copyWith(fontSize: 18),
                        ),
                        if (isCorrect)
                          Text('+10 pts 🪙', style: AndeanTextStyles.body.copyWith(
                              color: AndeanColors.success, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AndeanCard(
                padding: const EdgeInsets.all(14),
                borderRadius: 18,
                color: AndeanColors.background,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🔍', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    const Text('Lupa del Zorro:',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AndeanColors.secondary)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(question.lupaHint, style: AndeanTextStyles.body.copyWith(fontSize: 13)),
              ),
              const SizedBox(height: 10),
              Text(
                isCorrect ? question.feedbackCorrect : question.feedbackWrong,
                style: AndeanTextStyles.body,
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: onAudio,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AndeanColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.volume_up, color: AndeanColors.primary, size: 18),
                      SizedBox(width: 6),
                      Text('Escuchar explicación',
                          style: TextStyle(color: AndeanColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AndeanGameButton(
                text: 'CONTINUAR',
                onPressed: onContinue,
                color: isCorrect ? AndeanColors.success : AndeanColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionDialog extends StatelessWidget {
  final int nodeIndex;
  final int correct;
  final int total;

  const _CompletionDialog({
    required this.nodeIndex,
    required this.correct,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AndeanColors.goldGradient,
                shape: BoxShape.circle,
                boxShadow: AndeanColors.glowShadowOrange,
              ),
              child: const Text('🦊🏆', style: TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 16),
            Text(
              nodeIndex == 3 ? '¡COMPLETASTE TODA LA RUTA!' : '¡Nodo Completado!',
              style: AndeanTextStyles.headerMedium.copyWith(fontSize: 20, color: AndeanColors.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text('$correct / $total respuestas correctas',
                style: AndeanTextStyles.headerSmall),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AndeanColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text('+${correct * 10 + 30} pts 🪙',
                  style: AndeanTextStyles.statNumber.copyWith(color: AndeanColors.success)),
            ),
            if (nodeIndex + 1 < 4) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AndeanColors.headerGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('🔓 Nodo ${nodeIndex + 2} desbloqueado',
                    style: AndeanTextStyles.buttonText.copyWith(fontSize: 13)),
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Tiwula está orgulloso de ti.\nCada lección protege a tu comunidad.',
              textAlign: TextAlign.center,
              style: AndeanTextStyles.bodySmall,
            ),
            const SizedBox(height: 20),
            AndeanGameButton(
              text: 'VOLVER AL INICIO',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

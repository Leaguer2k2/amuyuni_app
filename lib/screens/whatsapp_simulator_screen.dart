import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';
import '../services/game_state.dart';
import '../data/ayllu_data.dart';
import '../theme/andean_theme.dart';
import '../widgets/andean_widgets.dart';

class WhatsAppSimulatorScreen extends StatefulWidget {
  const WhatsAppSimulatorScreen({super.key});

  @override
  State<WhatsAppSimulatorScreen> createState() => _WhatsAppSimulatorScreenState();
}

class _WhatsAppSimulatorScreenState extends State<WhatsAppSimulatorScreen> {
  int _scenarioIndex = 0;
  final List<_ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _answered = false;
  String _feedbackText = '';
  bool _isCorrect = false;
  late GameState _game;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _game = ChangeNotifierProvider.read(context);
    if (_messages.isEmpty) _loadScenario(0);
  }

  WhatsAppScenario get _scenario => whatsAppScenarios[_scenarioIndex];

  void _loadScenario(int index) {
    _messages.clear();
    _answered = false;
    _scenarioIndex = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.add(_ChatMessage(
          text: _scenario.initialMessage,
          isMe: false, isScam: true,
          sender: _scenario.scammerName,
        ));
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _goHome() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!context.mounted) return;
    final nav = Navigator.of(context);
    Future.microtask(() {
      if (context.mounted) {
        nav.pop();
      }
    });
  }

  void _sendOption(int optionIndex) {
    if (_answered) return;
    final isCorrectChoice = optionIndex == 1;
    setState(() {
      _messages.add(_ChatMessage(
        text: optionIndex == 0 ? _scenario.optionAText : _scenario.optionBText,
        isMe: true,
      ));
      _feedbackText = '🦊 ${optionIndex == 0 ? _scenario.feedbackA : _scenario.feedbackB}';
      _isCorrect = isCorrectChoice;
      _messages.add(_ChatMessage(text: _feedbackText, isMe: false, isTiwula: true));
      _answered = true;
    });
    _game.submitAnswer(2, isCorrectChoice);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final totalScenarios = whatsAppScenarios.length;

    return ResponsiveWrapper(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(totalScenarios),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFECE5DD),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  itemCount: _messages.length,
                  itemBuilder: (c, i) => _buildBubble(_messages[i]),
                ),
              ),
            ),
            if (!_answered) _buildQuickReplies() else _buildNav(totalScenarios),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int totalScenarios) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF075E54), Color(0xFF128C7E), Color(0xFF1B3A2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 4, 16),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _goHome,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_scenario.title,
                            style: AndeanTextStyles.headerSmall.copyWith(color: Colors.white, fontSize: 16)),
                        Text('${_scenarioIndex + 1} de $totalScenarios',
                            style: AndeanTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.7))),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up_outlined, color: Colors.white60),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('🔊 Tiwula te guía...'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AndeanProgressBar(
                value: (_scenarioIndex + 1) / totalScenarios,
                height: 8,
                gradientColors: [const Color(0xFF25D366), const Color(0xFF128C7E)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(_ChatMessage msg) {
    if (msg.isTiwula) {
      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isCorrect
                ? [AndeanColors.success.withValues(alpha: 0.12), AndeanColors.success.withValues(alpha: 0.04)]
                : [AndeanColors.redAlert.withValues(alpha: 0.12), AndeanColors.redAlert.withValues(alpha: 0.04)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isCorrect ? AndeanColors.success.withValues(alpha: 0.4) : AndeanColors.redAlert.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isCorrect ? AndeanColors.success : AndeanColors.redAlert,
                shape: BoxShape.circle,
              ),
              child: const Text('🦊', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isCorrect ? '¡Bien hecho!' : '¡Alerta!',
                      style: AndeanTextStyles.headerSmall.copyWith(
                          color: _isCorrect ? AndeanColors.success : AndeanColors.redAlert)),
                  const SizedBox(height: 4),
                  Text(msg.text.replaceFirst('🦊 ', ''),
                      style: AndeanTextStyles.body.copyWith(fontSize: 13,
                          color: _isCorrect ? AndeanColors.successDark : AndeanColors.redAlertDark)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!msg.isMe && msg.sender != null)
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: msg.isScam ? AndeanColors.redAlert.withValues(alpha: 0.15) : Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(msg.sender!, style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    color: msg.isScam ? AndeanColors.redAlert : Colors.black45)),
              ),
            ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: msg.isMe ? const Color(0xFFDCF8C6) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(14),
                topRight: const Radius.circular(14),
                bottomLeft: Radius.circular(msg.isMe ? 14 : 2),
                bottomRight: Radius.circular(msg.isMe ? 2 : 14),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(msg.text, style: TextStyle(
                fontSize: 13.5,
                color: msg.isScam ? AndeanColors.redAlertDark : Colors.black87,
                height: 1.35)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplies() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const Text('Elige tu respuesta:', style: AndeanTextStyles.label),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _sendOption(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        color: AndeanColors.redAlert.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AndeanColors.redAlert.withValues(alpha: 0.3)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33FF1744),
                            blurRadius: 8, offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _scenario.optionAText.length > 30
                            ? '${_scenario.optionAText.substring(0, 30)}...'
                            : _scenario.optionAText,
                        textAlign: TextAlign.center,
                        style: AndeanTextStyles.body.copyWith(
                            fontSize: 11, fontWeight: FontWeight.w700,
                            color: AndeanColors.redAlert),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _sendOption(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF25D366), Color(0xFF128C7E)]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3325D366),
                            blurRadius: 8, offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _scenario.optionBText.length > 30
                            ? '${_scenario.optionBText.substring(0, 30)}...'
                            : _scenario.optionBText,
                        textAlign: TextAlign.center,
                        style: AndeanTextStyles.buttonText.copyWith(fontSize: 11),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNav(int totalScenarios) {
    final isLast = _scenarioIndex + 1 >= totalScenarios;
    final allCorrect = _game.getNodeCorrect(2);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: isLast
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AndeanColors.success.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AndeanColors.success.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Text('🦊🏆', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '¡Completaste todos los escenarios!\n$allCorrect/${totalScenarios} correctos.',
                            style: AndeanTextStyles.body.copyWith(color: AndeanColors.successDark, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  AndeanGameButton(
                    text: 'VOLVER AL INICIO',
                    onPressed: _goHome,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _loadScenario(_scenarioIndex),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AndeanColors.secondary,
                        side: const BorderSide(color: AndeanColors.secondary),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, size: 18),
                          SizedBox(width: 4),
                          Text('Reintentar', style: TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AndeanGameButton(
                      text: 'Siguiente',
                      icon: Icons.arrow_forward,
                      onPressed: () => _loadScenario(_scenarioIndex + 1),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;
  final bool isScam;
  final String? sender;
  final bool isTiwula;

  const _ChatMessage({
    required this.text,
    required this.isMe,
    this.isScam = false,
    this.sender,
    this.isTiwula = false,
  });
}

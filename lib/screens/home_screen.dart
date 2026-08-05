import 'package:flutter/material.dart';
import '../main.dart';
import '../services/game_state.dart';
import '../theme/andean_theme.dart';
import '../widgets/andean_widgets.dart';
import 'lesson_screen.dart';
import 'whatsapp_simulator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.stop();
    _staggerController.dispose();
    super.dispose();
  }

  Widget _stagger(Widget child, int index) {
    final start = (index * 0.12).clamp(0.0, 1.0);
    final end = ((index * 0.12) + 0.35).clamp(0.0, 1.0);
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, _) {
        final t = _staggerController.value;
        if (t < start) return const SizedBox.shrink();
        final lt = ((t - start) / (end - start)).clamp(0.0, 1.0);
        final curved = Curves.easeOutCubic.transform(lt);
        return Opacity(
          opacity: curved,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - curved)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = ChangeNotifierProvider.of(context);

    return Scaffold(
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(game),
              const SizedBox(height: 24),
              _stagger(_buildTiwulaBanner(), 0),
              const SizedBox(height: 28),
              _stagger(_buildRouteTitle(), 1),
              const SizedBox(height: 16),
              _stagger(
                _buildPathNode(
                  context: context, game: game, nodeIndex: 0,
                  icon: Icons.qr_code_2_rounded, title: 'Phishing y QR Falsos',
                ), 2),
              _buildPathConnector(game, 0),
              _stagger(
                _buildPathNode(
                  context: context, game: game, nodeIndex: 1,
                  icon: Icons.remove_red_eye_rounded, title: 'IA vs Realidad',
                ), 3),
              _buildPathConnector(game, 1),
              _stagger(
                _buildPathNode(
                  context: context, game: game, nodeIndex: 2,
                  icon: Icons.chat_bubble_rounded, title: 'Simulador WhatsApp',
                ), 4),
              _buildPathConnector(game, 2),
              _stagger(
                _buildPathNode(
                  context: context, game: game, nodeIndex: 3,
                  icon: Icons.newspaper_rounded, title: 'Fake News y Emociones',
                ), 5),
              const SizedBox(height: 24),
              _stagger(_buildTiwulaQuote(), 6),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(GameState game) {
    return Container(/* unchanged header */
      decoration: const BoxDecoration(
        gradient: AndeanColors.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: AndeanColors.cardShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amuyuni', style: AndeanTextStyles.headerLarge.copyWith(fontSize: 30)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showProfileSheet(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 20, backgroundColor: Colors.white24,
                        child: Text('🦊', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildStatPill('🔥', '${game.streakDays}', 'Racha días')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatPill('❤️', '${game.lives}/${game.maxLives}', 'Vidas')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatPill('🪙', '${game.points}', 'Puntos Chaski')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String emoji, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AndeanColors.primary.withValues(alpha: 0.2),
            blurRadius: 10, offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(value, style: AndeanTextStyles.statNumber.copyWith(fontSize: 18)),
          Text(subtitle, style: AndeanTextStyles.statLabel.copyWith(fontSize: 9)),
        ],
      ),
    );
  }

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AndeanColors.goldGradient,
                  shape: BoxShape.circle,
                  boxShadow: AndeanColors.glowShadowOrange,
                ),
                child: const Text('🦊', style: TextStyle(fontSize: 48)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Vincular o Crear Perfil',
                style: AndeanTextStyles.headerMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Guarda tu progreso y compite con tu Ayllu',
                style: AndeanTextStyles.bodySmall,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('🦊 Perfil vinculado (simulado)'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: AndeanColors.success,
                      ),
                    );
                  },
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/24px-Google_%22G%22_logo.svg.png',
                    width: 22, height: 22,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.g_mobiledata, size: 22),
                  ),
                  label: const Text('Continuar con Google'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AndeanColors.textDark,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTiwulaBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AndeanColors.primary.withValues(alpha: 0.08), AndeanColors.secondary.withValues(alpha: 0.04)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AndeanColors.primary.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: AndeanColors.primary.withValues(alpha: 0.15),
              blurRadius: 20, offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const _FloatingTiwulaAvatar(),
            const SizedBox(width: 16),
            const Expanded(
              child: Text('Hola, soy Tiwula, ¿listo para entrenar el día de hoy?', style: AndeanTextStyles.headerSmall),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text('RUTA DE ENTRENAMIENTO', style: AndeanTextStyles.label),
          Spacer(),
          Text('4 Nodos', style: AndeanTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildPathNode({
    required BuildContext context, required GameState game, required int nodeIndex,
    required IconData icon, required String title,
  }) {
    final isUnlocked = game.isNodeUnlocked(nodeIndex);
    final totalInNode = game.getQuestionsCount(nodeIndex);
    final progress = game.getNodeProgress(nodeIndex);
    final completed = isUnlocked && progress >= totalInNode && totalInNode > 0;

    Color nodeColor;
    List<BoxShadow> shadows;
    String status;
    String emoji;

    if (completed) {
      nodeColor = AndeanColors.success;
      shadows = AndeanColors.glowShadowGreen;
      status = '$progress/$totalInNode completados';
      emoji = '✅';
    } else if (isUnlocked && progress > 0) {
      nodeColor = AndeanColors.primary;
      shadows = AndeanColors.glowShadowOrange;
      status = '$progress/$totalInNode en progreso';
      emoji = '🔥';
    } else if (isUnlocked) {
      nodeColor = AndeanColors.primary;
      shadows = AndeanColors.glowShadowOrange;
      status = '$totalInNode retos disponibles';
      emoji = '⚡';
    } else {
      nodeColor = AndeanColors.greyCool;
      shadows = [];
      status = '$totalInNode retos';
      emoji = '🔒';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: isUnlocked ? () {
          if (nodeIndex == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const WhatsAppSimulatorScreen()));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(nodeIndex: nodeIndex)));
          }
        } : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: nodeColor.withValues(alpha: isUnlocked ? 0.3 : 0.15), width: isUnlocked ? 2 : 1.5),
            boxShadow: [
              BoxShadow(
                color: nodeColor.withValues(alpha: 0.12),
                blurRadius: 20, offset: const Offset(0, 6),
              ),
              if (shadows.isNotEmpty) shadows.first,
            ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: nodeColor.withValues(alpha: completed ? 0.15 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: nodeColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AndeanTextStyles.headerSmall.copyWith(fontSize: 15)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text(emoji, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: nodeColor)),
                    ]),
                    if (isUnlocked && progress > 0 && !completed)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AndeanProgressBar(value: progress / totalInNode, height: 6, color: nodeColor),
                      ),
                  ],
                ),
              ),
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: nodeColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(Icons.chevron_right, color: nodeColor, size: 22),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPathConnector(GameState game, int nodeIndex) {
    final isUnlocked = game.isNodeUnlocked(nodeIndex);
    final totalInNode = game.getQuestionsCount(nodeIndex);
    final progress = game.getNodeProgress(nodeIndex);
    final completed = isUnlocked && progress >= totalInNode && totalInNode > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        height: 24,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 4, height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: completed
                    ? [AndeanColors.success, AndeanColors.success.withValues(alpha: 0.6)]
                    : isUnlocked
                        ? [AndeanColors.primary, AndeanColors.primary.withValues(alpha: 0.3)]
                        : [AndeanColors.greyCool.withValues(alpha: 0.35), AndeanColors.greyCool.withValues(alpha: 0.1)],
              ),
              boxShadow: completed
                  ? [BoxShadow(color: AndeanColors.success.withValues(alpha: 0.3), blurRadius: 6)]
                  : isUnlocked
                      ? [BoxShadow(color: AndeanColors.primary.withValues(alpha: 0.25), blurRadius: 6)]
                      : null,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTiwulaQuote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3A1C71), Color(0xFFFF5722)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AndeanColors.primary.withValues(alpha: 0.25),
              blurRadius: 20, offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          children: [
            _FloatingTiwulaAvatar(size: 38),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                '"La mejor defensa no es el miedo, es el conocimiento."',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingTiwulaAvatar extends StatefulWidget {
  final double size;
  const _FloatingTiwulaAvatar({this.size = 40});

  @override
  State<_FloatingTiwulaAvatar> createState() => _FloatingTiwulaAvatarState();
}

class _FloatingTiwulaAvatarState extends State<_FloatingTiwulaAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _floatAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.stop();
    _floatController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final textSize = widget.size * 0.9;
    final circleSize = widget.size + 12;
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnim.value * 6 - 3),
          child: Container(
            padding: EdgeInsets.all(circleSize / 8),
            decoration: BoxDecoration(
              gradient: AndeanColors.goldGradient,
              shape: BoxShape.circle,
              boxShadow: AndeanColors.glowShadowOrange,
            ),
            child: Text('🦊',
                style: TextStyle(fontSize: textSize)),
          ),
        );
      },
    );
  }
}

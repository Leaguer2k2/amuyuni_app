import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';
import '../services/game_state.dart';
import '../theme/andean_theme.dart';
import '../widgets/andean_widgets.dart';

class AylluScreen extends StatefulWidget {
  const AylluScreen({super.key});

  @override
  State<AylluScreen> createState() => _AylluScreenState();
}

class _AylluScreenState extends State<AylluScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _testimonioController = TextEditingController();
  bool _showingTestimonioInput = false;
  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _staggerController.forward();
  }

  Widget _stagger(Widget child, int index) {
    final start = (index * 0.08).clamp(0.0, 1.0);
    final end = ((index * 0.08) + 0.35).clamp(0.0, 1.0);
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

  void _completeMission(GameState game, int index) {
    final challenge = game.challenges[index];
    if (challenge.completed) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, -10)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AndeanColors.goldGradient,
                    shape: BoxShape.circle,
                    boxShadow: AndeanColors.glowShadowOrange,
                  ),
                  child: const Text('🦊🎓', style: TextStyle(fontSize: 36)),
                ),
                const SizedBox(height: 16),
                const Text('¿Completaste esta misión?',
                    style: AndeanTextStyles.headerMedium),
                const SizedBox(height: 10),
                Text('"${challenge.description}"',
                    textAlign: TextAlign.center, style: AndeanTextStyles.body),
                const SizedBox(height: 8),
                AndeanChip(label: challenge.role, color: AndeanColors.secondary),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AndeanColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text('+${challenge.rewardPoints} pts 🪙',
                      style: AndeanTextStyles.statNumber.copyWith(color: AndeanColors.success)),
                ),
                const SizedBox(height: 20),
                AndeanGameButton(
                  text: 'CONFIRMAR Y GANAR PUNTOS',
                  color: AndeanColors.success,
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => game.completeChallenge(index));
                  },
                ),
                const SizedBox(height: 8),
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Todavía no')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitTestimonio(GameState game) {
    final text = _testimonioController.text.trim();
    if (text.isEmpty) return;
    game.addTestimonial('🦊 $text');
    _testimonioController.clear();
    setState(() => _showingTestimonioInput = false);
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
              const SizedBox(height: 20),
              _stagger(_buildMissionsSection(game), 0),
              const SizedBox(height: 24),
              _stagger(_buildImpactSection(game), 1),
              const SizedBox(height: 24),
              _stagger(_buildCommunityBadgesSection(game), 2),
              const SizedBox(height: 24),
              _stagger(_buildBadgesSection(game), 3),
              const SizedBox(height: 24),
              _stagger(_buildTestimonialsSection(game), 4),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(GameState game) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AndeanColors.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mi Ayllu Digital', style: AndeanTextStyles.headerLarge),
              const SizedBox(height: 4),
              Text('${game.points} pts  ·  ${game.challenges.where((c) => c.completed).length} misiones',
                  style: AndeanTextStyles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionsSection(GameState game) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AndeanColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('🌱', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Misiones Intergeneracionales', style: AndeanTextStyles.headerSmall),
                    Text('Completa retos con tu comunidad', style: AndeanTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...game.challenges.asMap().entries.map((e) => _buildMissionCard(game, e.key, e.value)),
      ],
    );
  }

  Widget _buildMissionCard(GameState game, int index, AylluChallengeModel challenge) {
    final completed = challenge.completed;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: GestureDetector(
        onTap: completed ? null : () => _completeMission(game, index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: completed
                ? LinearGradient(
                    colors: [AndeanColors.success.withValues(alpha: 0.08), AndeanColors.success.withValues(alpha: 0.02)])
                : null,
            color: completed ? null : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: completed ? AndeanColors.success.withValues(alpha: 0.3) : Colors.grey.shade200,
              width: completed ? 2 : 1,
            ),
            boxShadow: completed ? [] : [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: completed ? AndeanColors.success : Colors.grey.shade200,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: completed ? AndeanColors.success : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: completed
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: AndeanTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration: completed ? TextDecoration.lineThrough : null,
                        color: completed ? AndeanColors.successDark : AndeanColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(challenge.description,
                        style: AndeanTextStyles.bodySmall.copyWith(fontSize: 11), maxLines: 2),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        AndeanChip(
                          label: challenge.role,
                          color: AndeanColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text('+${challenge.rewardPoints} pts',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700,
                                color: completed ? AndeanColors.success : AndeanColors.greyCool)),
                      ],
                    ),
                  ],
                ),
              ),
              if (completed)
                const Icon(Icons.verified, color: AndeanColors.success, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactSection(GameState game) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AndeanColors.secondaryLight.withValues(alpha: 0.1), AndeanColors.secondary.withValues(alpha: 0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AndeanColors.secondary.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AndeanColors.secondary, AndeanColors.secondaryLight]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.public, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Impacto de tu Municipio', style: AndeanTextStyles.headerSmall),
                      Text('Meta Común ONG', style: AndeanTextStyles.bodySmall),
                    ],
                  ),
                ),
                Text('${(game.communityProgress * 100).round()}%',
                    style: AndeanTextStyles.statNumber.copyWith(fontSize: 22, color: AndeanColors.secondary)),
              ],
            ),
            const SizedBox(height: 16),
            AndeanProgressBar(
              value: game.communityProgress,
              height: 14,
              gradientColors: [AndeanColors.secondary, AndeanColors.secondaryLight],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${game.communityLessons} / 10,000 lecciones',
                    style: AndeanTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: AndeanColors.secondary)),
                if (game.communityLessons >= 10000)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: AndeanColors.successGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('¡META!', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AndeanColors.secondary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AndeanColors.secondary, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Al llegar a 10,000 lecciones, una ONG aliada donará un aula digital con tablets y talleres a tu municipio.',
                      style: TextStyle(fontSize: 12, color: AndeanColors.secondary, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityBadgesSection(GameState game) {
    final missionsDone = game.challenges.where((c) => c.completed).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AndeanColors.goldGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('🏅', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              const Text('Tus Insignias Comunitarias', style: AndeanTextStyles.headerSmall),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.3,
            children: [
              _communityBadgeCard(
                icon: '🛡️',
                name: 'Guardián Digital',
                progressText: 'Desbloqueado',
                progressValue: 1.0,
                unlocked: true,
                color: AndeanColors.success,
              ),
              _communityBadgeCard(
                icon: '🦊',
                name: 'Ojo de Tiwula',
                progressText: 'Desbloqueado',
                progressValue: 1.0,
                unlocked: true,
                color: AndeanColors.primary,
              ),
              _communityBadgeCard(
                icon: '👵',
                name: 'Protector de Abuelos',
                progressText: 'En progreso: $missionsDone/3',
                progressValue: (missionsDone / 3).clamp(0.0, 1.0),
                unlocked: missionsDone >= 3,
                color: AndeanColors.gold,
              ),
              _communityBadgeCard(
                icon: '📡',
                name: 'Centinela del Radar',
                progressText: 'Bloqueado',
                progressValue: 0.0,
                unlocked: false,
                color: AndeanColors.greyCool,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _communityBadgeCard({
    required String icon,
    required String name,
    required String progressText,
    required double progressValue,
    required bool unlocked,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unlocked ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: unlocked ? color.withValues(alpha: 0.3) : Colors.grey.shade300,
          width: unlocked ? 2 : 1,
        ),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: unlocked
                  ? LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)])
                  : LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade200]),
              shape: BoxShape.circle,
            ),
            child: Text(
              icon,
              style: TextStyle(
                  fontSize: 22,
                  color: unlocked ? Colors.white : Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: AndeanTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: unlocked ? AndeanColors.textDark : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          if (!unlocked && progressValue > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 4,
                backgroundColor: Colors.grey.shade200,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
          ],
          Text(
            progressText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: unlocked ? color : Colors.grey,
            ),
          ),
          if (unlocked)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(Icons.verified, color: color, size: 16),
            ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection(GameState game) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AndeanColors.goldGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('🏆', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              const Text('Insignias y Trofeos', style: AndeanTextStyles.headerSmall),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: game.badges.map((badge) {
              return Container(
                width: 150,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: AndeanCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 22,
                  gradient: badge.unlocked
                      ? LinearGradient(
                          colors: [AndeanColors.gold.withValues(alpha: 0.15), AndeanColors.primary.withValues(alpha: 0.05)])
                      : null,
                  border: badge.unlocked
                      ? Border.all(color: AndeanColors.gold, width: 2)
                      : null,
                  boxShadow: badge.unlocked ? AndeanColors.glowShadowOrange : null,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: badge.unlocked
                              ? AndeanColors.goldGradient
                              : LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade200]),
                          shape: BoxShape.circle,
                        ),
                        child: Text(badge.icon,
                            style: TextStyle(fontSize: 28,
                                color: badge.unlocked ? Colors.white : Colors.grey.shade500)),
                      ),
                      const SizedBox(height: 8),
                      Text(badge.name,
                          textAlign: TextAlign.center,
                          style: AndeanTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 12,
                              color: badge.unlocked ? AndeanColors.textDark : Colors.grey)),
                      Text(badge.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                      if (!badge.unlocked) ...[
                        const SizedBox(height: 6),
                        AndeanProgressBar(
                          value: badge.progress,
                          height: 4,
                          color: AndeanColors.primary,
                        ),
                        const SizedBox(height: 3),
                        Text('${badge.progressCurrent}/${badge.progressTotal}',
                            style: const TextStyle(fontSize: 9, color: AndeanColors.greyCool)),
                      ] else
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(Icons.verified, color: AndeanColors.gold, size: 18),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialsSection(GameState game) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AndeanColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('💬', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              const Text('Muro de Compromisos', style: AndeanTextStyles.headerSmall),
            ],
          ),
          const SizedBox(height: 12),
          if (!_showingTestimonioInput)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _showingTestimonioInput = true),
                icon: const Icon(Icons.edit_note),
                label: const Text('Dejar mi testimonio'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AndeanColors.primary,
                  side: const BorderSide(color: AndeanColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            )
          else
            AndeanCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  TextField(
                    controller: _testimonioController,
                    maxLines: 2,
                    style: AndeanTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Ej: "Doña Martha aprendió a verificar QR..."',
                      hintStyle: AndeanTextStyles.bodySmall,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AndeanColors.primary.withValues(alpha: 0.3))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AndeanColors.primary, width: 2)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() { _showingTestimonioInput = false; _testimonioController.clear(); });
                        },
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 8),
                      AndeanGameButton(
                        text: 'Publicar',
                        height: 44,
                        borderRadius: 14,
                        onPressed: () => _submitTestimonio(game),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          ...game.testimonials.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        gradient: AndeanColors.goldGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(child: Text('🦊', style: TextStyle(fontSize: 16))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.replaceFirst('🦊 ', ''), style: AndeanTextStyles.body.copyWith(fontSize: 13)),
                          const SizedBox(height: 2),
                          const Text('Hace un momento', style: AndeanTextStyles.statLabel),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _testimonioController.dispose();
    _staggerController.stop();
    _staggerController.dispose();
    super.dispose();
  }
}

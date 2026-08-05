import 'package:flutter/material.dart';
import '../main.dart';
import '../services/game_state.dart';
import '../theme/andean_theme.dart';
import '../widgets/andean_widgets.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  String? _analysisResult;
  bool _analyzing = false;
  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _staggerController.forward();
  }

  Widget _stagger(Widget child, int index) {
    final start = (index * 0.1).clamp(0.0, 1.0);
    final end = ((index * 0.1) + 0.35).clamp(0.0, 1.0);
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

  final List<Map<String, String>> _reports = [
    {'title': '💸 Falso bono 500 Bs', 'detail': 'entel-bonos.com circula por WhatsApp. 47 reportes.', 'time': '10 min', 'severity': 'alta'},
    {'title': '🏦 Suplantación Banco Unión', 'detail': 'Piden código QR para "desbloquear cuenta".', 'time': '28 min', 'severity': 'alta'},
    {'title': '📱 QR clonados en ferias', 'detail': 'QR falsos pegados en puestos de El Alto.', 'time': '2 hrs', 'severity': 'media'},
    {'title': '🎉 Falso sorteo Entel', 'detail': 'Phishing con premio falso de 1.000 Bs.', 'time': '3 hrs', 'severity': 'media'},
    {'title': '📞 Falso soporte WhatsApp', 'detail': 'Robo de cuentas pidiendo código de 6 dígitos.', 'time': '5 hrs', 'severity': 'baja'},
  ];

  void _analyzeLink(GameState game) {
    final link = _linkController.text.trim();
    if (link.isEmpty) return;
    setState(() { _analyzing = true; _analysisResult = null; });
    game.checkLink(link);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _analyzing = false;
        final lower = link.toLowerCase();
        if (lower.contains('bono') || lower.contains('premio') || lower.contains('entel') ||
            lower.contains('gratis') || lower.contains('bit.ly') || lower.contains('regalo')) {
          _analysisResult = '⚠️ ¡PELIGRO! Tiwula detecta patrones de estafa en este enlace. No lo abras ni compartas.';
        } else {
          _analysisResult = '✅ Este enlace parece seguro, pero verifica siempre la fuente antes de hacer clic.';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = ChangeNotifierProvider.of(context);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          onPressed: () => _showReportSheet(context, game),
          backgroundColor: AndeanColors.redAlert,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          icon: const Icon(Icons.warning_amber_rounded),
          label: const Text('+ Reportar Estafa / Número',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _stagger(_buildAlertBanner(), 0),
              const SizedBox(height: 24),
              _stagger(_buildLinkChecker(game), 1),
              if (_analysisResult != null) ...[
                const SizedBox(height: 12),
                _stagger(_buildAnalysisResult(), 2),
              ],
              const SizedBox(height: 24),
              _stagger(_buildReportsList(), _analysisResult != null ? 3 : 2),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.radar, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Radar Colectivo', style: AndeanTextStyles.headerLarge),
                        Text('Alertas comunitarias en tiempo real',
                            style: AndeanTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AndeanColors.success,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: AndeanColors.glowShadowGreen,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 6, height: 6,
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white, shape: BoxShape.circle))),
                        SizedBox(width: 6),
                        Text('EN VIVO',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AndeanColors.alertGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AndeanColors.redAlert.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 10),
                const Text('🚨 ALERTA NACIONAL',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                        fontSize: 14, letterSpacing: 1.2)),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Circula enlace falso de bono en WhatsApp. No abras entel-bonos.com. ¡Protege a tu familia!',
              style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkChecker(GameState game) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AndeanCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AndeanColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.link, color: AndeanColors.accent, size: 18),
                ),
                const SizedBox(width: 8),
                const Text('Verificar enlace sospechoso', style: AndeanTextStyles.headerSmall),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _linkController,
              style: AndeanTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Pega el link o mensaje aquí...',
                hintStyle: AndeanTextStyles.bodySmall,
                filled: true,
                fillColor: AndeanColors.background,
                prefixIcon: const Icon(Icons.link, color: AndeanColors.greyCool),
                suffixIcon: _analyzing
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.5)),
                      )
                    : IconButton(
                        icon: const Icon(Icons.search, color: AndeanColors.primary),
                        onPressed: () => _analyzeLink(game),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _analyzeLink(game),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResult() {
    final isDanger = _analysisResult!.startsWith('⚠️');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDanger
                ? [AndeanColors.redAlert.withValues(alpha: 0.08), AndeanColors.orangeAlert.withValues(alpha: 0.04)]
                : [AndeanColors.success.withValues(alpha: 0.08), AndeanColors.success.withValues(alpha: 0.02)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDanger ? AndeanColors.redAlert.withValues(alpha: 0.3) : AndeanColors.success.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isDanger ? '🦊' : '✅', style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(_analysisResult!, style: AndeanTextStyles.body.copyWith(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('Reportes de la comunidad', style: AndeanTextStyles.headerSmall),
              Spacer(),
              Text('🟢 En vivo', style: AndeanTextStyles.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._reports.map((r) => _buildReportCard(r)),
      ],
    );
  }

  Widget _buildReportCard(Map<String, String> report) {
    Color severityColor;
    Color bg;
    switch (report['severity']) {
      case 'alta':
        severityColor = AndeanColors.redAlert;
        bg = AndeanColors.redAlert.withValues(alpha: 0.04);
        break;
      case 'media':
        severityColor = AndeanColors.orangeAlert;
        bg = AndeanColors.orangeAlert.withValues(alpha: 0.04);
        break;
      default:
        severityColor = AndeanColors.accent;
        bg = AndeanColors.accent.withValues(alpha: 0.04);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5, height: 45,
              decoration: BoxDecoration(
                color: severityColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(report['title']!, style: AndeanTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(report['detail']!, style: AndeanTextStyles.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(report['time']!, style: AndeanTextStyles.statLabel),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    report['severity']!.toUpperCase(),
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: severityColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReportSheet(BuildContext context, GameState game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AndeanColors.redAlert.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.report_problem,
                            color: AndeanColors.redAlert, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reportar Estafa',
                                style: AndeanTextStyles.headerSmall),
                            Text('Ayuda a proteger a tu comunidad',
                                style: AndeanTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _reportController,
                    maxLines: 3,
                    style: AndeanTextStyles.body,
                    decoration: InputDecoration(
                      hintText:
                          'Describe la estafa o pega el número sospechoso...',
                      hintStyle: AndeanTextStyles.bodySmall,
                      filled: true,
                      fillColor: AndeanColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: AndeanColors.primary, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AndeanGameButton(
                    text: 'Enviar Reporte a la Comunidad (+20 pts)',
                    icon: Icons.send_rounded,
                    color: AndeanColors.redAlert,
                    onPressed: () {
                      final text = _reportController.text.trim();
                      if (text.isEmpty) return;
                      game.checkLink(text);
                      game.addTestimonial('🚨 ${_reportController.text.trim()}');
                      _reportController.clear();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              '✅ ¡Reporte enviado! +20 pts. Gracias por proteger a tu Ayllu.'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: AndeanColors.success,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _linkController.dispose();
    _reportController.dispose();
    _staggerController.stop();
    _staggerController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import '../theme/andean_theme.dart';

class AndeanGameButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final double height;
  final double borderRadius;
  final bool isLoading;

  const AndeanGameButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.icon,
    this.height = 56,
    this.borderRadius = 18,
    this.isLoading = false,
  });

  @override
  State<AndeanGameButton> createState() => _AndeanGameButtonState();
}

class _AndeanGameButtonState extends State<AndeanGameButton> {
  bool _isPressed = false;

  Color get _effectiveColor => widget.color ?? AndeanColors.primary;

  Color get _darkColor {
    final hsl = HSLColor.fromColor(_effectiveColor);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: disabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: disabled ? null : () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutBack,
        child: Container(
          height: widget.height,
        margin: EdgeInsets.only(
          top: _isPressed ? (_darkColor == _effectiveColor ? 2 : 4) : 0,
        ),
          decoration: BoxDecoration(
            color: disabled
                ? AndeanColors.greyCool.withValues(alpha: 0.3)
                : _effectiveColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border(
                bottom: BorderSide(
                  color: disabled || _isPressed ? Colors.transparent : _darkColor,
                  width: 4,
                ),
              ),
            boxShadow: disabled
                ? []
                : _isPressed
                    ? []
                    : AndeanColors.buttonShadow,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isLoading)
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              else if (widget.icon != null) ...[
                Icon(widget.icon,
                    color: widget.textColor ?? Colors.white, size: 22),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: AndeanTextStyles.buttonText.copyWith(
                  color: widget.textColor ?? Colors.white,
                  fontSize: 15,
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

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 600,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding,
        child: child,
      ),
    );
  }
}

class AndeanHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? bottom;
  final double height;

  const AndeanHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.bottom,
    this.height = 130,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: AndeanColors.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: AndeanColors.cardShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.08,
                child: Icon(Icons.terrain,
                    size: 180, color: AndeanColors.textLight),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: AndeanTextStyles.headerLarge),
                            if (subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(subtitle!,
                                  style: AndeanTextStyles.bodySmall.copyWith(
                                      color: AndeanColors.textLight
                                          .withValues(alpha: 0.8))),
                            ],
                          ],
                        ),
                      ),
                      if (actions != null) ...actions!,
                    ],
                  ),
                  const Spacer(),
                  if (bottom != null) bottom!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AndeanCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double borderRadius;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final Border? border;

  const AndeanCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderRadius = 24,
    this.gradient,
    this.boxShadow,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AndeanColors.surface) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: boxShadow ?? AndeanColors.cardShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }
    return card;
  }
}

class AndeanChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final bool glowing;

  const AndeanChip({
    super.key,
    required this.label,
    this.icon,
    this.color = AndeanColors.primary,
    this.glowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: glowing ? AndeanColors.glowShadowOrange : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class AndeanProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? color;
  final List<Color>? gradientColors;

  const AndeanProgressBar({
    super.key,
    required this.value,
    this.height = 10,
    this.color,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth * animatedValue;
              return Container(
                height: height,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: barWidth,
                      decoration: BoxDecoration(
                        gradient: gradientColors != null
                            ? LinearGradient(colors: gradientColors!)
                            : LinearGradient(
                                colors: [color ?? AndeanColors.primary,
                                  (color ?? AndeanColors.primary).withValues(alpha: 0.8)]),
                        borderRadius: BorderRadius.circular(height / 2),
                        boxShadow: [
                          BoxShadow(
                            color: (color ?? AndeanColors.primary)
                                .withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    if (barWidth > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: height * 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(height / 2),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class StaggeredEntrance extends StatefulWidget {
  final List<Widget> children;
  final Duration baseDelay;

  const StaggeredEntrance({
    super.key,
    required this.children,
    this.baseDelay = const Duration(milliseconds: 60),
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500 + (widget.children.length * 80),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (index) {
        final startDelay = index * widget.baseDelay.inMilliseconds / 1000.0;
        final animStart = (startDelay / _controller.duration!.inMilliseconds * 1000.0).clamp(0.0, 1.0);
        final animEnd = ((startDelay + 0.4) / _controller.duration!.inMilliseconds * 1000.0).clamp(0.0, 1.0);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value;
            if (t < animStart) return const SizedBox.shrink();
            final localT = ((t - animStart) / (animEnd - animStart)).clamp(0.0, 1.0);
            final curvedT = Curves.easeOutCubic.transform(localT);
            return Opacity(
              opacity: curvedT,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - curvedT)),
                child: widget.children[index],
              ),
            );
          },
          child: widget.children[index],
        );
      }),
    );
  }
}

class AnimatedBadge extends StatefulWidget {
  final Widget child;
  final bool isUnlocked;
  final bool justUnlocked;

  const AnimatedBadge({
    super.key,
    required this.child,
    required this.isUnlocked,
    this.justUnlocked = false,
  });

  @override
  State<AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<AnimatedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  bool _wasJustUnlocked = false;

  @override
  void initState() {
    super.initState();
    _wasJustUnlocked = widget.justUnlocked;
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isUnlocked && widget.justUnlocked) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_wasJustUnlocked && widget.isUnlocked && widget.justUnlocked) {
      _wasJustUnlocked = true;
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.stop();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isUnlocked || !widget.justUnlocked) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final scale = 1.0 + (_pulse.value * 0.06);
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AndeanColors.gold.withValues(alpha: 0.3 * _pulse.value),
                  blurRadius: 16.0 + (_pulse.value * 8.0),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

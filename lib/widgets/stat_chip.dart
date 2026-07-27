import 'package:flutter/material.dart';
import '../theme/andean_theme.dart';

class StatChip extends StatelessWidget {
  final String icon;
  final String label;

  const StatChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AndeanColors.textDark.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: AndeanColors.textDark.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            label,
            style: AndeanTextStyles.statNumber.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

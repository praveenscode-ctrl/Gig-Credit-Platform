import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';

/// GigCredit Pillar Waterfall Chart — stacked bar build-up from base to final score
class PillarWaterfallChart extends StatelessWidget {
  final Map<String, int> contributions;
  final int finalScore;

  const PillarWaterfallChart({
    super.key,
    required this.contributions,
    required this.finalScore,
  });

  @override
  Widget build(BuildContext context) {
    if (contributions.isEmpty) return const SizedBox.shrink();

    final entries = contributions.entries.toList();
    entries.removeWhere((e) => e.key == 'floor');
    entries.sort((a, b) => b.value.compareTo(a.value));

    const maxPts = 600.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderCard),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Build-Up (Waterfall)',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),

          // Floor
          _buildBarRow('Base Score', 300, 300, 600, AppColors.borderCard, 0),

          // Pillars
          ...entries.asMap().entries.map((e) {
            final idx = e.key;
            final pillar = e.value.key;
            final pts = e.value.value;
            final color = idx == entries.length - 1 ? AppColors.warning : AppColors.greenPrimary;
            return _buildBarRow(pillar, pts, maxPts.toInt(), 600, color, idx + 1);
          }),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: AppColors.borderCard),
          ),

          // Final total
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('Total',
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: AppColors.ctaGradient,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 40,
                child: Text(
                  finalScore.toString(),
                  textAlign: TextAlign.right,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.greenPrimary,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }

  Widget _buildBarRow(String label, int value, int maxVal, int totalScale, Color color, int index) {
    final fraction = (value / totalScale).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  flex: (fraction * 1000).toInt(),
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                Expanded(
                  flex: ((1.0 - fraction) * 1000).toInt(),
                  child: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 40,
            child: Text(
              '+$value',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: label == 'Base Score' ? AppColors.textMuted : color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(begin: -0.05),
    );
  }
}

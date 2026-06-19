import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';

/// GigCredit Score Gauge — Animated circular ring with score counter
/// Green-themed with grade-colored ring
class ScoreGaugeWidget extends StatelessWidget {
  final int finalScore;
  final String grade;
  final String riskBand;

  const ScoreGaugeWidget({
    super.key,
    required this.finalScore,
    required this.grade,
    required this.riskBand,
  });

  @override
  Widget build(BuildContext context) {
    final gradeColor = AppColors.gradeColor(grade);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderCard),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 300, end: finalScore.toDouble()),
                  duration: 1500.ms,
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    final progress = (value - 300) / 600;
                    return CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: AppColors.borderCard,
                      color: gradeColor,
                      strokeCap: StrokeCap.round,
                    );
                  },
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 300, end: finalScore),
                    duration: 1500.ms,
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Text(
                        value.toString(),
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 48,
                          color: gradeColor,
                          fontWeight: FontWeight.w900,
                        ),
                      );
                    },
                  ),
                  Text(
                    '/ 900',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: gradeColor.withValues(alpha: 0.25)),
                ),
                child: Text(
                  'Grade: $grade',
                  style: AppTypography.labelLarge.copyWith(
                    color: gradeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getRiskColor(riskBand).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _getRiskColor(riskBand).withValues(alpha: 0.25)),
                ),
                child: Text(
                  '$riskBand Risk',
                  style: AppTypography.labelLarge.copyWith(
                    color: _getRiskColor(riskBand),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 1500.ms),
        ],
      ),
    );
  }

  Color _getRiskColor(String riskBand) {
    switch (riskBand.toLowerCase()) {
      case 'low':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'high':
      case 'very high':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}

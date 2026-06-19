import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../models/trajectory_result.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';

/// GigCredit Score Trajectory Widget — projected score paths
class TrajectoryWidget extends StatelessWidget {
  final TrajectoryResult trajectory;

  const TrajectoryWidget({super.key, required this.trajectory});

  @override
  Widget build(BuildContext context) {
    final paths = [
      {'label': '7-Day Maintain', 'value': trajectory.sevenDay.projectedScore, 'color': AppColors.textSecondary},
      {'label': '1-3M Projected', 'value': trajectory.oneToThreeMonths.projectedScore, 'color': AppColors.greenBright},
      {'label': 'Optimized', 'value': trajectory.fullPotential.projectedScore, 'color': AppColors.greenPrimary},
    ];

    final allScores = paths.map((p) => p['value'] as int).toList()..add(300)..add(900);
    final minScore = allScores.reduce((a, b) => a < b ? a : b);
    final maxScore = allScores.reduce((a, b) => a > b ? a : b);
    final range = maxScore - minScore;

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
            'Score Trajectory (Projected)',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 32),
          Column(
            children: paths.asMap().entries.map((e) {
              final idx = e.key;
              final path = e.value;
              final label = path['label'] as String;
              final score = path['value'] as int;
              final color = path['color'] as Color;

              final fraction = ((score - minScore) / range).clamp(0.0, 1.0);

              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        label,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.borderCard,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: fraction,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          Positioned(
                            left: fraction > 0 ? null : 0,
                            right: fraction > 0 ? null : 0,
                            child: FractionallySizedBox(
                              widthFactor: fraction,
                              alignment: Alignment.centerRight,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.25),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    score.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: Duration(milliseconds: 200 * idx)).slideX(begin: -0.1),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

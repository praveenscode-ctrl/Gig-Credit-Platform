import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/score_pillar_model.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';

/// GigCredit Pillar Radar Chart — polygon profile of all 7 pillars
class PillarRadarChart extends StatelessWidget {
  final List<ScorePillarModel> pillars;

  const PillarRadarChart({super.key, required this.pillars});

  @override
  Widget build(BuildContext context) {
    if (pillars.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderCard),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            'Score Radar Profile',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                radarBackgroundColor: Colors.transparent,
                radarBorderData: const BorderSide(color: AppColors.borderCard),
                gridBorderData: const BorderSide(color: AppColors.borderCard, width: 0.5),
                tickCount: 4,
                ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
                tickBorderData: const BorderSide(color: AppColors.borderCard, width: 0.5),
                getTitle: (index, angle) {
                  return RadarChartTitle(
                    text: pillars[index].code,
                    angle: 0,
                    positionPercentageOffset: 0.1,
                  );
                },
                dataSets: [
                  // Outer conformal bound
                  RadarDataSet(
                    fillColor: AppColors.greenBright.withValues(alpha: 0.08),
                    borderColor: Colors.transparent,
                    entryRadius: 0,
                    dataEntries: pillars.map((p) {
                      return RadarEntry(value: p.conformalHigh / p.maxScore);
                    }).toList(),
                  ),
                  // Inner conformal bound
                  RadarDataSet(
                    fillColor: AppColors.bgCard,
                    borderColor: Colors.transparent,
                    entryRadius: 0,
                    dataEntries: pillars.map((p) {
                      return RadarEntry(value: p.conformalLow / p.maxScore);
                    }).toList(),
                  ),
                  // Actual calibrated score line
                  RadarDataSet(
                    fillColor: Colors.transparent,
                    borderColor: AppColors.greenPrimary,
                    borderWidth: 2,
                    entryRadius: 3,
                    dataEntries: pillars.map((p) {
                      return RadarEntry(value: p.calibratedScore);
                    }).toList(),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 12, height: 2, color: AppColors.greenPrimary),
              const SizedBox(width: 8),
              Text('Score', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(width: 16),
              Container(width: 12, height: 12, color: AppColors.greenBright.withValues(alpha: 0.15)),
              const SizedBox(width: 8),
              Text('Confidence Band', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../models/score_pillar_model.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';

/// GigCredit Pillar Detail Card — expandable pillar info with progress bar
class PillarDetailCard extends StatefulWidget {
  final ScorePillarModel pillar;

  const PillarDetailCard({super.key, required this.pillar});

  @override
  State<PillarDetailCard> createState() => _PillarDetailCardState();
}

class _PillarDetailCardState extends State<PillarDetailCard> {
  @override
  Widget build(BuildContext context) {
    final p = widget.pillar;
    final pct = (p.score / p.maxScore).clamp(0.0, 1.0);
    final pillarColor = AppColors.pillarColor(p.code);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCard),
        boxShadow: AppColors.cardShadow,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greenMuted,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  p.code,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.greenPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  p.title,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${p.score}/${p.maxScore}',
                style: AppTypography.labelLarge.copyWith(
                  color: pillarColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderCard,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: pct,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: pillarColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppColors.borderCard),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetaStat('Calibrated', p.calibratedScore.toStringAsFixed(3)),
                      _buildMetaStat('Weight', '${(p.weight * 100).toInt()}%'),
                      _buildMetaStat(
                        'Confidence',
                        '[${p.conformalLow.toStringAsFixed(1)}, ${p.conformalHigh.toStringAsFixed(1)}]',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

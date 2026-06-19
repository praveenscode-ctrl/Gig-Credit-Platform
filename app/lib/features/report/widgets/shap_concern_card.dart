import 'package:flutter/material.dart';
import '../../../models/shap_factor_model.dart';
import '../../../models/actionable_item.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';

/// GigCredit SHAP Concern Card — amber/orange accent for negative factors
class ShapConcernCard extends StatelessWidget {
  final ShapFactorModel factor;

  const ShapConcernCard({super.key, required this.factor});

  @override
  Widget build(BuildContext context) {
    final isImmediate = factor.actionType == ActionabilityTier.immediate;
    final color = isImmediate ? AppColors.warning : const Color(0xFFFFC107);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Icon(Icons.warning_amber_rounded, color: color, size: 24),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    factor.featureName,
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.arrow_right_alt, color: color, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'How to improve',
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

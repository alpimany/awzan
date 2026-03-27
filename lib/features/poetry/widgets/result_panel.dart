import 'package:flutter/material.dart';

import 'package:awzan/app/theme.dart';
import 'package:awzan/features/poetry/models/analysis_result.dart';
import 'package:awzan/shared/utils/responsive.dart';

class ResultPanel extends StatelessWidget {
  const ResultPanel({super.key, required this.result});

  final AnalysisResult result;

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: result.hasError
              ? AppColors.red.withOpacity(0.45)
              : AppColors.gold.withOpacity(0.25),
        ),
      ),
      child: result.hasError ? _buildError(context) : _buildResults(context),
    );
  }

  Widget _buildError(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: AppColors.red,
          size: scaledFont(context, 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            result.error!,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Scheherazade',
              fontSize: scaledFont(context, 16),
              color: AppColors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (result.baharName.isNotEmpty) ...[
          _ResultRow(
            label: 'البحر',
            value: result.baharName,
            valueColor: AppColors.green,
          ),
          const Divider(color: AppColors.border, height: 12),
        ],
        _ResultRow(
          label: 'التفعيلات',
          value: result.tafaeel,
          valueColor: AppColors.goldLight,
        ),
        const Divider(color: AppColors.border, height: 12),
        _ResultRow(
          label: 'الكتابة العروضية',
          value: result.prosody,
          valueColor: AppColors.blue,
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'Scheherazade',
            fontSize: scaledFont(context, 14),
            color: AppColors.textSec,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Scheherazade',
              fontSize: scaledFont(context, 17),
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
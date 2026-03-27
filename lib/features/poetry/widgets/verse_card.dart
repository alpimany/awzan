import 'package:flutter/material.dart';

import 'package:awzan/app/theme.dart';
import 'package:awzan/features/poetry/models/analysis_result.dart';
import 'package:awzan/features/poetry/models/verse.dart';
import 'package:awzan/features/poetry/widgets/poetry_verse.dart';
import 'package:awzan/features/poetry/widgets/result_panel.dart';
import 'package:awzan/shared/utils/responsive.dart';
import 'package:awzan/shared/widgets/icon_btn.dart';

class VerseCard extends StatelessWidget {
  const VerseCard({
    super.key,
    required this.index,
    required this.verse,
    required this.isActive,
    required this.result,
    required this.onFocus,
    required this.onChange,
    this.onDelete,
  });

  final int index;
  final Verse verse;
  final bool isActive;
  final AnalysisResult result;
  final VoidCallback onFocus;
  final void Function(Map) onChange;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final s = screenScale(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 5 * s),
      decoration: BoxDecoration(
        color: isActive ? AppColors.card : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? AppColors.gold.withOpacity(0.5) : AppColors.border,
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.08),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12 * s, 8 * s, 12 * s, 12 * s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.gold.withOpacity(0.15)
                        : AppColors.border.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${index + 1}',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Scheherazade',
                      fontSize: scaledFont(context, 13),
                      color: isActive ? AppColors.goldLight : AppColors.textSec,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                if (onDelete != null)
                  IconBtn(
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.textSec,
                    hoverColor: AppColors.red,
                    onTap: onDelete!,
                    size: scaledFont(context, 18),
                  ),
              ],
            ),
            SizedBox(height: 8 * s),

            PoetryVerse(verse: verse, onFocus: onFocus, onChange: onChange),

            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: ResultPanel(result: result),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:awzan/app/theme.dart';
import 'package:awzan/features/poetry/models/verse.dart';
import 'package:awzan/features/poetry/widgets/poetry_input.dart';

class PoetryVerse extends StatelessWidget {
  const PoetryVerse({
    super.key,
    required this.verse,
    this.onChange,
    this.onFocus,
  });

  final Verse verse;
  final void Function(Map result)? onChange;
  final void Function()? onFocus;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 560;

        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PoetryInput(
                initialValue: verse.chest.value,
                onChange: onChange,
                onFocus: onFocus,
                alignment: MainAxisAlignment.start,
                placeholder: 'الصدر',
              ),
              const SizedBox(height: 8),
              PoetryInput(
                initialValue: verse.rump.value,
                onChange: onChange,
                onFocus: onFocus,
                alignment: MainAxisAlignment.end,
                placeholder: 'العجز',
              ),
            ],
          );
        }

        return Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: PoetryInput(
                initialValue: verse.chest.value,
                onChange: onChange,
                onFocus: onFocus,
                alignment: MainAxisAlignment.start,
                placeholder: 'الصدر',
              ),
            ),
            Container(
              width: 1,
              height: 42,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: AppColors.border,
            ),
            Expanded(
              child: PoetryInput(
                initialValue: verse.rump.value,
                onChange: onChange,
                onFocus: onFocus,
                alignment: MainAxisAlignment.end,
                placeholder: 'العجز',
              ),
            ),
          ],
        );
      },
    );
  }
}
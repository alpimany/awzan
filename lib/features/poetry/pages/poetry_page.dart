import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:awzan/app/theme.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_writing.dart';
import 'package:awzan/features/poetry/models/analysis_result.dart';
import 'package:awzan/features/poetry/models/verse.dart';
import 'package:awzan/features/poetry/widgets/verse_card.dart';
import 'package:awzan/shared/utils/responsive.dart';
import 'package:awzan/shared/widgets/app_header.dart';

class PoetryPage extends StatefulWidget {
  const PoetryPage({super.key});

  @override
  State<PoetryPage> createState() => _PoetryPageState();
}

class _PoetryPageState extends State<PoetryPage> {
  final ScrollController _scrollController = ScrollController();
  int? _activeIndex;

  late List<Verse> _verses;
  late List<AnalysisResult> _results;

  @override
  void initState() {
    super.initState();
    _verses  = List.generate(6, (_) => Verse());
    _results = List.generate(6, (_) => AnalysisResult.empty());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ─── State helpers ──────────────────────────────────────────────────────────

  void _onInputTap(int index) => setState(() => _activeIndex = index);

  void _resetFocus(int index) {
    if (_activeIndex == index) setState(() => _activeIndex = null);
  }

  void _addVerse() {
    setState(() {
      _verses.add(Verse());
      _results.add(AnalysisResult.empty());
    });
  }

  void _removeVerse(int index) {
    if (_verses.length <= 1) return;
    setState(() {
      _verses.removeAt(index);
      _results.removeAt(index);
      if (_activeIndex == index) {
        _activeIndex = null;
      } else if (_activeIndex != null && _activeIndex! > index) {
        _activeIndex = _activeIndex! - 1;
      }
    });
  }

  void _handleChange(int index, Map result) {
    setState(() {
      if (result.containsKey('errors')) {
        final errors = result['errors'] as List<ProsodyError>;
        _results[index] = AnalysisResult.error(
          errors.any((e) => e.type == ProsodyErrorType.twoSaken)
              ? 'لا يَجُوز التِقاءُ ساكِنين إلا في القافية'
              : 'خطأ في التحليل',
        );
      } else {
        _results[index] = AnalysisResult.ok(
          prosody:   result['output']    as String,
          tafaeel:   result['tafaeel']   as String,
          baharName: result['baharName'] as String,
        );
      }
    });
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDesktop = !kIsWeb &&
        (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        top: !isDesktop,
        bottom: false,
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 780),
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _verses.length,
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: MediaQuery.paddingOf(context).bottom + 100,
                    ),
                    itemBuilder: (context, index) {
                      final isActive = _activeIndex == index;
                      final isDimmed = _activeIndex != null && !isActive;

                      return TapRegion(
                        onTapOutside: (_) => _resetFocus(index),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: isDimmed ? 0.38 : 1.0,
                          child: VerseCard(
                            index: index,
                            verse: _verses[index],
                            isActive: isActive,
                            result: _results[index],
                            onFocus: () => _onInputTap(index),
                            onChange: (r) => _handleChange(index, r),
                            onDelete: _verses.length > 1
                                ? () => _removeVerse(index)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Add-verse FAB ────────────────────────────────────────────────────────
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SafeArea(
        top: false,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: FloatingActionButton.extended(
            onPressed: _addVerse,
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.bg,
            elevation: 4,
            icon: const Icon(Icons.add, size: 20),
            label: Text(
              'بيت جديد',
              style: TextStyle(
                fontFamily: 'Scheherazade',
                fontSize: scaledFont(context, 18),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
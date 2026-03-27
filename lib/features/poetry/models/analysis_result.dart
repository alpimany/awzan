class AnalysisResult {
  const AnalysisResult._({
    this.prosody = '',
    this.tafaeel = '',
    this.baharName = '',
    this.error,
    this.isEmpty = false,
  });

  final String prosody;
  final String tafaeel;
  final String baharName;
  final String? error;
  final bool isEmpty;

  factory AnalysisResult.empty() => const AnalysisResult._(isEmpty: true);

  factory AnalysisResult.error(String msg) => AnalysisResult._(error: msg);

  factory AnalysisResult.ok({
    required String prosody,
    required String tafaeel,
    required String baharName,
  }) => AnalysisResult._(
    prosody: prosody,
    tafaeel: tafaeel,
    baharName: baharName,
  );

  bool get hasError => error != null;
}
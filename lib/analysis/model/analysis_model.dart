class AnalysisResult {
  final double buyProbability;
  final double sellProbability;
  final double longProbability;
  final double shortProbability;
  final String recommendation;
  final String confidenceLevel;
  final String analysisDetails;
  final String timestamp;

  AnalysisResult({
    required this.buyProbability,
    required this.sellProbability,
    required this.longProbability,
    required this.shortProbability,
    required this.recommendation,
    required this.confidenceLevel,
    this.analysisDetails = '',
    this.timestamp = '',
  });

  factory AnalysisResult.empty() {
    return AnalysisResult(
      buyProbability: 0,
      sellProbability: 0,
      longProbability: 0,
      shortProbability: 0,
      recommendation: '',
      confidenceLevel: '',
      analysisDetails: '',
      timestamp: '',
    );
  }
}

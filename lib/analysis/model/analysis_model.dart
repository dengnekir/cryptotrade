class AnalysisResult {
  final double buyProbability;
  final double sellProbability;
  final double longProbability;
  final double shortProbability;
  final String recommendation;
  final String confidenceLevel;
  final String analysisDetails;
  final String timestamp;
  final String coinPair;

  AnalysisResult({
    required this.buyProbability,
    required this.sellProbability,
    required this.longProbability,
    required this.shortProbability,
    required this.recommendation,
    required this.confidenceLevel,
    this.analysisDetails = '',
    this.timestamp = '',
    this.coinPair = 'ETH/USDT',
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
      coinPair: 'ETH/USDT',
    );
  }

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      buyProbability: (json['buyProbability'] as num?)?.toDouble() ?? 0.0,
      sellProbability: (json['sellProbability'] as num?)?.toDouble() ?? 0.0,
      longProbability: (json['longProbability'] as num?)?.toDouble() ?? 0.0,
      shortProbability: (json['shortProbability'] as num?)?.toDouble() ?? 0.0,
      recommendation: json['recommendation']?.toString() ?? '',
      confidenceLevel: json['confidenceLevel']?.toString() ?? '',
      analysisDetails: json['analysisDetails']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ?? '',
      coinPair: json['coinPair']?.toString() ?? 'ETH/USDT',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buyProbability': buyProbability,
      'sellProbability': sellProbability,
      'longProbability': longProbability,
      'shortProbability': shortProbability,
      'recommendation': recommendation,
      'confidenceLevel': confidenceLevel,
      'analysisDetails': analysisDetails,
      'timestamp': timestamp,
      'coinPair': coinPair,
    };
  }
}

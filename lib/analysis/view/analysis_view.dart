import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/providers/analysis_provider.dart';
import '../../core/widgets/colors.dart';
import '../../analysis/model/analysis_model.dart';

class AnalysisView extends ConsumerWidget {
  const AnalysisView({Key? key}) : super(key: key);

  Future<void> _pickImage(
      BuildContext context, WidgetRef ref, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      ref.read(analysisProvider.notifier).selectImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Coin Analizi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(analysisProvider.notifier).resetAnalysis();
        },
        color: Colors.orange.shade600,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAnalysisModes(context, ref),
              const SizedBox(height: 16),
              _buildImagePickerSection(context, ref, analysisState),
              const SizedBox(height: 24),
              if (analysisState.selectedImage != null) _buildAnalyzeButton(ref),
              const SizedBox(height: 24),
              if (analysisState.isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange.shade600,
                  ),
                ),
              if (analysisState.error != null)
                _buildErrorWidget(analysisState.error!),
              if (analysisState.analysisResult != null) ...[
                _buildRiskScoreWidget(analysisState),
                const SizedBox(height: 16),
                _buildAnalysisResultSection(analysisState),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerSection(
      BuildContext context, WidgetRef ref, AnalysisState analysisState) {
    return GestureDetector(
      onTap: () => _showImagePickerBottomSheet(context, ref),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorss.primaryColor.withOpacity(0.1),
              Colors.transparent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorss.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: analysisState.selectedImage == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 100,
                      color: colorss.primaryColor.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Resim Seçmek İçin Dokunun',
                      style: TextStyle(
                        color: colorss.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Image.file(
                  analysisState.selectedImage!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade50,
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Resim Kaynağı Seç',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildImageSourceButton(context, ref,
                    icon: Icons.photo_camera,
                    label: 'Kamera',
                    source: ImageSource.camera),
                const SizedBox(height: 12),
                _buildImageSourceButton(context, ref,
                    icon: Icons.photo_library,
                    label: 'Galeri',
                    source: ImageSource.gallery),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceButton(BuildContext context, WidgetRef ref,
      {required IconData icon,
      required String label,
      required ImageSource source}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        _pickImage(context, ref, source);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade100,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange.shade700),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton(WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade600,
            Colors.deepOrange.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => ref.read(analysisProvider.notifier).analyzeImage(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.analytics_outlined, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Analizi Başlat',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Hata: $error',
        style: TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAnalysisDetailsSection(AnalysisResult result) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detaylı Teknik Analiz',
            style: TextStyle(
              color: colorss.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._parseAnalysisDetails(result.analysisDetails),
        ],
      ),
    );
  }

  // Detaylı analiz metnini parse eden ve widget'a çeviren metot
  List<Widget> _parseAnalysisDetails(String details) {
    // Detayları satır satır böl
    final lines = details.split('\n');

    // Widget listesi ve işlenmiş başlıkları takip etmek için set
    List<Widget> detailWidgets = [];
    Set<String> processedTitles = {};

    for (var line in lines) {
      // Yıldızlı başlıkları ve içeriklerini ayır
      if (line.startsWith('* **') &&
          !line.contains('LONG') &&
          !line.contains('SHORT') &&
          !line.contains('Tarih')) {
        // Başlığı ve içeriği çıkar
        final title = line.replaceAll('* **', '').replaceAll(':**', '');

        // Eğer bu başlık daha önce işlenmediyse
        if (!processedTitles.contains(title)) {
          // Kalın yazıları bul
          if (line.contains('* **')) {
            detailWidgets.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 20,
                    ),
                  ],
                ),
              ),
            );

            // İşlenmiş başlıkları işaretle
            processedTitles.add(title);
          }
        }
      }
    }

    return detailWidgets;
  }

  Widget _buildAnalysisResultSection(AnalysisState analysisState) {
    final result = analysisState.analysisResult!;
    final selectedMode = analysisState.selectedMode;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analiz Sonuçları',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildProbabilityRow('Al', result.buyProbability, Colors.green),
                _buildProbabilityRow('Sat', result.sellProbability, Colors.red),
                _buildProbabilityRow(
                    'Long', result.longProbability, Colors.blue),
                _buildProbabilityRow(
                    'Short', result.shortProbability, Colors.orange),
                const SizedBox(height: 16),
                _buildModeSpecificInfo(selectedMode, result),
              ],
            ),
          ),
        ),
        _buildAnalysisDetailsSection(result),
      ],
    );
  }

  Widget _buildProbabilityRow(String label, double probability, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: LinearProgressIndicator(
              value: probability / 100,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${probability.toStringAsFixed(1)}%',
            style: TextStyle(
              color: colorss.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSpecificInfo(AnalysisMode mode, AnalysisResult result) {
    double probability;
    String label;
    Color color;

    switch (mode) {
      case AnalysisMode.buy:
        probability = result.buyProbability;
        label = 'Al';
        color = Colors.green;
        break;
      case AnalysisMode.sell:
        probability = result.sellProbability;
        label = 'Sat';
        color = Colors.red;
        break;
      case AnalysisMode.long:
        probability = result.longProbability;
        label = 'Long';
        color = Colors.blue;
        break;
      case AnalysisMode.short:
        probability = result.shortProbability;
        label = 'Short';
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label Önceliği',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '%${probability.toStringAsFixed(1)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisModes(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(analysisProvider);
    final selectedMode = analysisState.selectedMode;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAnalysisModeButton(
            label: 'Al',
            isSelected: selectedMode == AnalysisMode.buy,
            onTap: () => ref
                .read(analysisProvider.notifier)
                .selectMode(AnalysisMode.buy),
            color: Colors.green,
          ),
          _buildAnalysisModeButton(
            label: 'Sat',
            isSelected: selectedMode == AnalysisMode.sell,
            onTap: () => ref
                .read(analysisProvider.notifier)
                .selectMode(AnalysisMode.sell),
            color: Colors.red,
          ),
          _buildAnalysisModeButton(
            label: 'Long',
            isSelected: selectedMode == AnalysisMode.long,
            onTap: () => ref
                .read(analysisProvider.notifier)
                .selectMode(AnalysisMode.long),
            color: Colors.blue,
          ),
          _buildAnalysisModeButton(
            label: 'Short',
            isSelected: selectedMode == AnalysisMode.short,
            onTap: () => ref
                .read(analysisProvider.notifier)
                .selectMode(AnalysisMode.short),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisModeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Risk skoru hesaplama fonksiyonu
  double _calculateRiskScore(AnalysisState analysisState) {
    final result = analysisState.analysisResult;
    if (result == null) return 0.0;

    // Basit risk skoru hesaplama algoritması
    double riskScore = 0.0;
    riskScore += result.sellProbability * 0.4;
    riskScore += result.shortProbability * 0.3;
    riskScore += (100 - result.buyProbability) * 0.2;
    riskScore += (100 - result.longProbability) * 0.1;

    return riskScore;
  }

  Widget _buildRiskScoreWidget(AnalysisState analysisState) {
    final riskScore = _calculateRiskScore(analysisState);
    Color riskColor = riskScore < 30
        ? Colors.green
        : riskScore < 60
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Risk Skoru',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${riskScore.toStringAsFixed(1)}%',
            style: TextStyle(
              color: riskColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

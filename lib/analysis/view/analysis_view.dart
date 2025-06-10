import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/providers/analysis_provider.dart';
import '../../core/widgets/colors.dart';

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
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        backgroundColor: colorss.backgroundColor,
        elevation: 0,
        title: Text(
          'Coin Analizi',
          style: TextStyle(color: colorss.textColor),
        ),
        actions: analysisState.selectedImage != null
            ? [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () =>
                      ref.read(analysisProvider.notifier).resetAnalysis(),
                )
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImagePickerSection(context, ref, analysisState),
            const SizedBox(height: 24),
            if (analysisState.selectedImage != null) _buildAnalyzeButton(ref),
            const SizedBox(height: 24),
            if (analysisState.isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: colorss.primaryColor,
                ),
              ),
            if (analysisState.error != null)
              _buildErrorWidget(analysisState.error!),
            if (analysisState.analysisResult != null)
              _buildAnalysisResultSection(analysisState),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerSection(
      BuildContext context, WidgetRef ref, AnalysisState analysisState) {
    return Container(
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
      child: Column(
        children: [
          analysisState.selectedImage == null
              ? Image.asset(
                  'assets/images/chart_placeholder.png', // Placeholder görsel ekleyin
                  height: 250,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  analysisState.selectedImage!,
                  height: 250,
                  fit: BoxFit.cover,
                ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(context, ref, ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Kamera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorss.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      _pickImage(context, ref, ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeri'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorss.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton(WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(analysisProvider.notifier).analyzeImage(),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorss.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Analizi Başlat',
        style: TextStyle(fontSize: 18),
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

  Widget _buildAnalysisResultSection(AnalysisState analysisState) {
    final result = analysisState.analysisResult!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorss.backgroundColorLight.withOpacity(0.1),
            colorss.backgroundColorLight.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorss.textColorSecondary.withOpacity(0.1),
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
                color: colorss.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildProbabilityRow('AL', result.buyProbability, Colors.green),
            _buildProbabilityRow('SAT', result.sellProbability, Colors.red),
            _buildProbabilityRow('LONG', result.longProbability, Colors.blue),
            _buildProbabilityRow(
                'SHORT', result.shortProbability, Colors.orange),
            const SizedBox(height: 16),
            _buildInfoRow('Tavsiye', result.recommendation),
            _buildInfoRow('Güven Seviyesi', result.confidenceLevel),
          ],
        ),
      ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colorss.textColorSecondary,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colorss.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../model/analysis_model.dart';
import '../viewmodel/analysis_viewmodel.dart';

class AnalysisView extends StatelessWidget {
  const AnalysisView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafik Analizi'),
        centerTitle: true,
        actions: [
          Consumer<AnalysisViewModel>(
            builder: (context, viewModel, _) {
              return viewModel.analysisResult != null
                  ? IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => viewModel.resetAnalysis(),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<AnalysisViewModel>(
        builder: (context, viewModel, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImageSection(context, viewModel),
                    const SizedBox(height: 20),
                    if (viewModel.selectedImage != null)
                      _buildSelectedImage(viewModel.selectedImage!),
                    const SizedBox(height: 20),
                    if (viewModel.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (viewModel.error != null)
                      _buildErrorWidget(viewModel.error!)
                    else if (viewModel.analysisResult != null)
                      _buildAnalysisResults(viewModel.analysisResult!),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, AnalysisViewModel viewModel) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Analiz edilecek grafiği seçin',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageButton(
                  context,
                  'Kamera',
                  Icons.camera_alt,
                  () => _pickImage(context, ImageSource.camera),
                ),
                _buildImageButton(
                  context,
                  'Galeri',
                  Icons.photo_library,
                  () => _pickImage(context, ImageSource.gallery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImage(File image) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seçilen Grafik',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResults(AnalysisResult result) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analiz Sonuçları',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildResultRow('Alış Olasılığı:',
                '${result.buyProbability.toStringAsFixed(1)}%'),
            _buildResultRow('Satış Olasılığı:',
                '${result.sellProbability.toStringAsFixed(1)}%'),
            _buildResultRow('Long Olasılığı:',
                '${result.longProbability.toStringAsFixed(1)}%'),
            _buildResultRow('Short Olasılığı:',
                '${result.shortProbability.toStringAsFixed(1)}%'),
            const Divider(color: Colors.grey),
            _buildRecommendationCard(
                result.recommendation, result.confidenceLevel),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
      String recommendation, String confidenceLevel) {
    Color cardColor;

    if (recommendation.contains('AL') || recommendation.contains('LONG')) {
      cardColor = Colors.green[900]!;
    } else if (recommendation.contains('SAT') ||
        recommendation.contains('SHORT')) {
      cardColor = Colors.red[900]!;
    } else {
      cardColor = Colors.amber[900]!;
    }

    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              recommendation,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Güven Seviyesi: $confidenceLevel',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Card(
      color: Colors.red[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          error,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        final viewModel = context.read<AnalysisViewModel>();
        await viewModel.analyzeImage(File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim seçilirken bir hata oluştu: $e')),
      );
    }
  }
}

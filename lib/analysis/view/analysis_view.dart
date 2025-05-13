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
      ),
      body: Consumer<AnalysisViewModel>(
        builder: (context, viewModel, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImageSection(context, viewModel),
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
            _buildResultRow('Alış Olasılığı:',
                '${result.buyProbability.toStringAsFixed(1)}%'),
            _buildResultRow('Satış Olasılığı:',
                '${result.sellProbability.toStringAsFixed(1)}%'),
            _buildResultRow('Long Olasılığı:',
                '${result.longProbability.toStringAsFixed(1)}%'),
            _buildResultRow('Short Olasılığı:',
                '${result.shortProbability.toStringAsFixed(1)}%'),
            const Divider(color: Colors.grey),
            _buildResultRow('Tavsiye:', result.recommendation),
            _buildResultRow('Güven Seviyesi:', result.confidenceLevel),
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

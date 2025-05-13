import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/live_support_viewmodel.dart';

class LiveSupportView extends StatelessWidget {
  const LiveSupportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LiveSupportViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Canlı Destek'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Consumer<LiveSupportViewModel>(
          builder: (context, viewModel, child) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.support_agent,
                      size: 100,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Size nasıl yardımcı olabiliriz?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Destek ekibimiz WhatsApp üzerinden size yardımcı olmak için hazır.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => viewModel.openWhatsApp(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.message, size: 28),
                      label: const Text(
                        'WhatsApp ile İletişime Geç',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/widgets/colors.dart';

class SubscriptionPlanView extends StatelessWidget {
  const SubscriptionPlanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Abonelik Planları',
          style: TextStyle(
            color: colorss.backgroundColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorss.backgroundColorDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildPlanCard(
              title: 'Günlük Plan',
              price: '1\$',
              duration: 'gün',
              features: [
                'Günlük 3 analiz sinyali',
                'Temel destek',
                'Standart analiz araçları',
              ],
              isPopular: false,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              title: 'Aylık Plan',
              price: '8\$',
              duration: 'ay',
              features: [
                'Sınırsız analiz sinyali',
                'Öncelikli destek',
                'Gelişmiş analiz araçları',
                'Özel stratejiler',
              ],
              isPopular: true,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              title: '6 Aylık Plan',
              price: '15\$',
              duration: '6 ay',
              features: [
                'Sınırsız analiz sinyali',
                'VIP destek',
                'Premium analiz araçları',
                'Özel stratejiler',
                'Erken erişim özellikleri',
              ],
              isPopular: false,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              title: 'Yıllık Plan',
              price: '20\$',
              duration: 'yıl',
              features: [
                'Sınırsız analiz sinyali',
                'VIP destek',
                'Premium analiz araçları',
                'Özel stratejiler',
                'Erken erişim özellikleri',
                'Özel danışmanlık',
              ],
              isPopular: false,
              bestValue: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.card_membership,
                color: colorss.primaryColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'Premium Özellikler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorss.backgroundColorDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Yapay zeka destekli kripto analiz sistemimizden maksimum fayda sağlamak için size en uygun planı seçin.',
            style: TextStyle(
              fontSize: 16,
              color: colorss.backgroundColorDark,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String duration,
    required List<String> features,
    bool isPopular = false,
    bool bestValue = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isPopular
                ? colorss.primaryColor.withOpacity(0.15)
                : colorss.backgroundColorLight.withOpacity(0.1),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular
              ? colorss.primaryColor
              : colorss.backgroundColorLight.withOpacity(0.2),
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorss.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'En Popüler',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (bestValue)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'En İyi Değer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorss.backgroundColorDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isPopular
                            ? colorss.primaryColor
                            : colorss.backgroundColorDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '/ $duration',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorss.backgroundColorDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: features.map((feature) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: isPopular
                                ? colorss.primaryColor
                                : colorss.backgroundColorDark,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            feature,
                            style: TextStyle(
                              color: colorss.backgroundColorDark,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Abonelik seçme işlemi
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular
                          ? colorss.primaryColor
                          : colorss.primaryColorDark,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Seç',
                      style: TextStyle(
                        color: isPopular
                            ? Colors.white
                            : colorss.backgroundColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

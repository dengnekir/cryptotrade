import 'package:flutter/material.dart';
import '../../../core/widgets/colors.dart';

class BillingHistoryView extends StatelessWidget {
  const BillingHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        backgroundColor: colorss.backgroundColor,
        elevation: 0,
        title: Text(
          'Fatura Geçmişi',
          style: TextStyle(color: colorss.textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorss.textColor),
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
            _buildBillingList(),
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
                Icons.receipt_long,
                color: colorss.primaryColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'Fatura Geçmişi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorss.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tüm abonelik ödemelerinizi ve fatura detaylarınızı buradan görüntüleyebilirsiniz.',
            style: TextStyle(
              fontSize: 16,
              color: colorss.textColorSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingList() {
    // TODO: Implement real billing history
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Örnek veri
      itemBuilder: (context, index) {
        return _buildBillingCard(
          date: DateTime.now().subtract(Duration(days: index * 30)),
          planName: 'Aylık Premium Plan',
          amount: 8.0,
          status: index == 0 ? 'Aktif' : 'Tamamlandı',
        );
      },
    );
  }

  Widget _buildBillingCard({
    required DateTime date,
    required String planName,
    required double amount,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Show billing details
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorss.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt,
                    color: colorss.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planName,
                        style: TextStyle(
                          color: colorss.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: TextStyle(
                          color: colorss.textColorSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: colorss.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: status == 'Aktif'
                            ? Colors.green.withOpacity(0.1)
                            : colorss.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: status == 'Aktif'
                              ? Colors.green
                              : colorss.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/widgets/colors.dart';

class FavoriteCoinsView extends StatefulWidget {
  const FavoriteCoinsView({Key? key}) : super(key: key);

  @override
  State<FavoriteCoinsView> createState() => _FavoriteCoinsViewState();
}

class _FavoriteCoinsViewState extends State<FavoriteCoinsView> {
  final List<Map<String, dynamic>> _coins = [
    {
      'symbol': 'BTC',
      'name': 'Bitcoin',
      'isFavorite': true,
      'price': 65432.10,
      'change': 2.5,
    },
    {
      'symbol': 'ETH',
      'name': 'Ethereum',
      'isFavorite': true,
      'price': 3456.78,
      'change': -1.2,
    },
    // TODO: Add more coins
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        backgroundColor: colorss.backgroundColor,
        elevation: 0,
        title: Text(
          'Favori Coinler',
          style: TextStyle(color: colorss.textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorss.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildCoinList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        style: TextStyle(color: colorss.textColor),
        decoration: InputDecoration(
          hintText: 'Coin ara...',
          hintStyle: TextStyle(color: colorss.textColorSecondary),
          prefixIcon: Icon(Icons.search, color: colorss.textColorSecondary),
          filled: true,
          fillColor: colorss.backgroundColorLight.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorss.textColorSecondary.withOpacity(0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorss.primaryColor),
          ),
        ),
        onChanged: (value) {
          // TODO: Implement search functionality
        },
      ),
    );
  }

  Widget _buildCoinList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _coins.length,
      itemBuilder: (context, index) {
        final coin = _coins[index];
        return _buildCoinCard(coin);
      },
    );
  }

  Widget _buildCoinCard(Map<String, dynamic> coin) {
    final bool isPositive = (coin['change'] as double) >= 0;

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
            // TODO: Navigate to coin details
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorss.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    coin['symbol'],
                    style: TextStyle(
                      color: colorss.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin['name'],
                        style: TextStyle(
                          color: colorss.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${coin['price'].toStringAsFixed(2)}',
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${isPositive ? '+' : ''}${coin['change']}%',
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: Icon(
                        coin['isFavorite'] ? Icons.star : Icons.star_border,
                        color: coin['isFavorite']
                            ? colorss.primaryColor
                            : colorss.textColorSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          coin['isFavorite'] = !coin['isFavorite'];
                        });
                      },
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

import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Products'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProductCard(
              context: context,
              title: "Trackify Pro",
              subtitle: "Advanced tracking with max features",
              price: "\$99.00",
              features: [
                'Real-time 1s tracking',
                'Remote engine cut-off',
                'Detailed Fuel Analytics'
              ],
              color: Colors.purple.shade50,
              iconColor: Colors.purple,
            ),
            const SizedBox(height: 16),
            _buildProductCard(
              context: context,
              title: "Trackify Go",
              subtitle: "Standard tracking for everyday use",
              price: "\$69.00",
              features: [
                'Real-time 5s tracking',
                'Anti-theft alerts',
                'Basic journey logs'
              ],
              color: Colors.blue.shade50,
              iconColor: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildProductCard(
              context: context,
              title: "Trackify Lite",
              subtitle: "Basic locator device",
              price: "\$39.00",
              features: ['Location updates', 'Geo-fencing', 'Battery monitor'],
              color: Colors.green.shade50,
              iconColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String price,
    required List<String> features,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: iconColor.withOpacity(0.8),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                  ],
                ),
                Text(
                  price,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Features:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: iconColor, size: 20),
                          const SizedBox(width: 8),
                          Text(feature),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added $title to cart!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Buy Now',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

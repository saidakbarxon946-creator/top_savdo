import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ilova haqida (Info)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.storefront_rounded, size: 64, color: AppTheme.primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.appName,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              AppConstants.appTagline,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'TopSavdo — bu O\'zbekiston bo\'ylab sotuvchi va xaridorlarni birlashtiruvchi zamonaviy elektron platforma. Biz orqali istalgan mahsulotingizni tez va xavfsiz sotishingiz hamda qulay narxlarda xarid qilishingiz mumkin.',
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildFeatureTile(Icons.verified_user_rounded, 'Ishonchli xavfsizlik', 'Foydalanuvchi ma\'lumotlari to\'liq himoyalangan'),
                    const Divider(height: 20),
                    _buildFeatureTile(Icons.speed_rounded, 'Tezkor e\'lonlar', 'E\'lon joylash atigi 1 daqiqa vaqt oladi'),
                    const Divider(height: 20),
                    _buildFeatureTile(Icons.chat_bubble_rounded, 'Qulay chat', 'Sotuvchilar bilan bevosita va tezkor muloqot'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

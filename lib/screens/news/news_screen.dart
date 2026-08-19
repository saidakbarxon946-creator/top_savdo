import 'package:flutter/material.dart';
import '../../core/theme.dart';

class NewsArticle {
  final String title;
  final String category;
  final String date;
  final String imageUrl;
  final String summary;

  NewsArticle({
    required this.title,
    required this.category,
    required this.date,
    required this.imageUrl,
    required this.summary,
  });
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  List<NewsArticle> get _articles => [
        NewsArticle(
          title: 'TopSavdo platformasida yangi xavfsizlik yangilanishi e\'lon qilindi',
          category: 'Yangiliklar',
          date: '19 Avgust, 2026',
          imageUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=600&q=80',
          summary: 'Foydalanuvchilar o\'rtasidagi bitimlar xavfsizligini oshirish maqsadida yangi verifikatsiya tizimi yo\'lga qo\'yildi.',
        ),
        NewsArticle(
          title: 'Mahsulotni tez va qimmatroq sotishning 5 ta oltin qoidasi',
          category: 'Maslahatlar',
          date: '18 Avgust, 2026',
          imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=600&q=80',
          summary: 'Sifatli rasmlar va to\'g\'ri sarlavha tanlash orqali e\'loningiz ko\'rishlar sonini 3 barobarga oshiring.',
        ),
        NewsArticle(
          title: 'Elektronika bozori 2026: Eng ommabop smartfonlar reytingi',
          category: 'Tahlil',
          date: '15 Avgust, 2026',
          imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=600&q=80',
          summary: 'O\'zbekistonda eng ko\'p sotilgan va xarid qilingan gadjetlar bo\'yicha tahliliy maqola.',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yangiliklar va Blog (News)'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final item = _articles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  item.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            item.date,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.title,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.summary,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

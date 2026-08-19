import 'package:flutter/material.dart';
import '../core/theme.dart';

class BannerItemData {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final IconData icon;

  BannerItemData({
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.icon,
  });
}

class CarouselBanner extends StatefulWidget {
  final List<BannerItemData>? customBanners;
  const CarouselBanner({super.key, this.customBanners});

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<BannerItemData> get _banners => widget.customBanners ?? [
    BannerItemData(
      title: 'Yozgi Katta Chegirmalar! 🔥',
      subtitle: 'Barcha maishiy texnikalarga 30% gacha arzon narxlar',
      gradientColors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      icon: Icons.local_offer_rounded,
    ),
    BannerItemData(
      title: 'Top Savdo VIP E\'lonlar ⭐',
      subtitle: 'E\'loningizni eng yuqorida 10 barobar tezroq sotishingiz mumkin',
      gradientColors: [const Color(0xFFEC4899), const Color(0xFFF59E0B)],
      icon: Icons.star_rounded,
    ),
    BannerItemData(
      title: 'Xavfsiz va Kafolatlangan Bitim ✅',
      subtitle: 'Sotuvchi va xaridor o\'rtasida bevosita ishonchli aloqa',
      gradientColors: [const Color(0xFF10B981), const Color(0xFF3B82F6)],
      icon: Icons.verified_user_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: banner.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: banner.gradientColors.first.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(banner.icon, color: Colors.white, size: 32),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentIndex == index ? 20 : 6,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppTheme.primaryColor
                    : Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

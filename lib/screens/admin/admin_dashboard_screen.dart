import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _bannerTitleController = TextEditingController();
  final _bannerSubtitleController = TextEditingController();
  bool _isAdminLoggedIn = true;

  final List<Map<String, String>> _adminBanners = [
    {'title': 'Yozgi Katta Chegirmalar! 🔥', 'subtitle': 'Barcha maishiy texnikalarga 30% gacha arzon narxlar'},
    {'title': 'Top Savdo VIP E\'lonlar ⭐', 'subtitle': 'E\'loningizni eng yuqorida 10 barobar tezroq sotishingiz mumkin'},
    {'title': 'Xavfsiz va Kafolatlangan Bitim ✅', 'subtitle': 'Sotuvchi va xaridor o\'rtasida bevosita ishonchli aloqa'},
  ];

  final List<Map<String, String>> _reportedPosts = [
    {'id': 'p1', 'title': 'iPhone 15 Pro Max', 'reason': 'Spam yoki yolg\'on narx', 'status': 'Ko\'rilmoqda'},
    {'id': 'p2', 'title': 'Cobalt 2023', 'reason': 'Rasm va tavsif mos kelmaydi', 'status': 'Kutilmoqda'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkAdminSession();
  }

  Future<void> _checkAdminSession() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('logged_in_email') ?? '';

    final isAdmin = (user != null && user.email?.toLowerCase() == 'admen@gmail.com') ||
        savedEmail.toLowerCase() == 'admen@gmail.com';

    setState(() {
      _isAdminLoggedIn = isAdmin;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerTitleController.dispose();
    _bannerSubtitleController.dispose();
    super.dispose();
  }

  void _addBanner() {
    if (_bannerTitleController.text.trim().isEmpty) return;

    setState(() {
      _adminBanners.add({
        'title': _bannerTitleController.text.trim(),
        'subtitle': _bannerSubtitleController.text.trim(),
      });
    });

    _bannerTitleController.clear();
    _bannerSubtitleController.clear();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Yangi Carousel banner muvaffaqiyatli qo\'shildi!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddBannerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yangi Carousel Banner Qo\'shish'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _bannerTitleController,
              decoration: const InputDecoration(
                labelText: 'Banner sarlavhasi',
                hintText: 'Masalan: Bayram Chegirmalari',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bannerSubtitleController,
              decoration: const InputDecoration(
                labelText: 'Qisqa izoh',
                hintText: 'Masalan: Barcha tovarlarga chegirma',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: _addBanner,
            child: const Text('Qo\'shish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isAdminLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Panel')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.gavel_rounded, size: 64, color: Colors.redAccent),
                const SizedBox(height: 20),
                Text(
                  'Ruxsat etilmagan!',
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Admin panelga kirish uchun faqat admen@gmail.com hisobi orqali tizimga kiring.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Admin Xisobiga Kirish'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.view_carousel_rounded), text: 'Banners'),
            Tab(icon: Icon(Icons.article_rounded), text: 'E\'lonlar'),
            Tab(icon: Icon(Icons.people_rounded), text: 'Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Carousel Banners Control
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bosh sahifa bannerlari (${_adminBanners.length})',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddBannerDialog,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Banner qo\'shish'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _adminBanners.length,
                    itemBuilder: (context, index) {
                      final item = _adminBanners[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.view_carousel_rounded, color: AppTheme.primaryColor),
                          ),
                          title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(item['subtitle']!),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                _adminBanners.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tab 2: Post Moderation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Moderatordagi E\'lonlar',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _reportedPosts.length,
                    itemBuilder: (context, index) {
                      final post = _reportedPosts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(post['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Shikoyat: ${post['reason']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                                onPressed: () {
                                  setState(() {
                                    _reportedPosts.removeAt(index);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
                                onPressed: () {
                                  setState(() {
                                    _reportedPosts.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tab 3: Users Control
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('A')),
                    title: Text('Admin User', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('admen@gmail.com'),
                    trailing: Chip(label: Text('Admin'), backgroundColor: Colors.deepOrangeAccent),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('J')),
                    title: Text('Javohirbek (User)'),
                    subtitle: Text('javohir@gmail.com'),
                    trailing: Chip(label: Text('Active')),
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

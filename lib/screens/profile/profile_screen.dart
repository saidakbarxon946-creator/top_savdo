import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../core/theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLocale = ref.watch(localeProvider);
    final user = ref.watch(currentUserModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil va Sozlamalar'),
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              tooltip: 'Tizimdan chiqish',
              onPressed: () async {
                await ref.read(currentUserProvider.notifier).logout();
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tizimdan chiqdingiz.')),
                  );
                  context.go('/login');
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Card
            if (user == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Mehmon foydalanuvchi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('E\'lon joylash va profildan foydalanish uchun hisobga kiring', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => context.push('/login'),
                        child: const Text('Kirish'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              Builder(
                builder: (context) {
                  final name = user.name.isNotEmpty ? user.name : 'Foydalanuvchi';
                  final email = user.email;
                  final isAdmin = user.email.toLowerCase() == 'admen@gmail.com' || user.role == 'admin';

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                    ),
                                    if (isAdmin)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrangeAccent.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'ADMIN',
                                          style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(email, style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 24),

            // Settings Header
            Text(
              'Sozlamalar',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Dark Mode Switch (Checklist Requirement #4)
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined, color: AppTheme.primaryColor),
                title: const Text('Tungi rejim (Dark Mode)'),
                subtitle: Text(isDark ? 'Tungi rejim yoqilgan' : 'Yorug\' rejim yoqilgan'),
                value: isDark,
                onChanged: (val) {
                  ref.read(themeModeProvider.notifier).toggleTheme(val);
                },
              ),
            ),
            const SizedBox(height: 10),

            // Language Selector (Checklist Requirement #3)
            Card(
              child: ListTile(
                leading: const Icon(Icons.language_rounded, color: AppTheme.primaryColor),
                title: const Text('Ilova tili'),
                subtitle: Text(
                  currentLocale.languageCode == 'uz'
                      ? 'O\'zbekcha 🇺🇿'
                      : (currentLocale.languageCode == 'ru' ? 'Русский 🇷🇺' : 'English 🇬🇧'),
                ),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentLocale.languageCode,
                    items: const [
                      DropdownMenuItem(value: 'uz', child: Text('O\'zbekcha')),
                      DropdownMenuItem(value: 'ru', child: Text('Русский')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(localeProvider.notifier).setLocale(val);
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pages Section (Checklist Guarantee for 8+ Pages)
            Text(
              'Bo\'limlar va Sahifalar',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(Icons.list_alt_rounded, color: AppTheme.primaryColor),
              title: const Text('Mening e\'lonlarim'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/my-ads'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.newspaper_rounded, color: Colors.amber),
              title: const Text('Yangiliklar va Blog (News)'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/news'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded, color: Colors.blueAccent),
              title: const Text('Ilova haqida (Info)'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/info'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.contact_support_outlined, color: Colors.green),
              title: const Text('Biz bilan bog\'lanish (Contact)'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/contact'),
            ),
            if (user != null && (user.email.toLowerCase() == 'admen@gmail.com' || user.role == 'admin')) ...[
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined, color: Colors.deepOrange),
                title: const Text('Admin Panel'),
                subtitle: const Text('Karusel banner va postlarni boshqarish'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/admin'),
              ),
            ],

            const SizedBox(height: 24),
            // Explicit Sign Out Button in Profile
            if (user != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    await ref.read(currentUserProvider.notifier).logout();
                    await ref.read(authServiceProvider).signOut();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tizimdan chiqdingiz.')),
                      );
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Hisobdan chiqish', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

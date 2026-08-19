import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String keyLanguageCode = 'language_code';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('uz')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(keyLanguageCode) ?? 'uz';
    state = Locale(langCode);
  }

  Future<void> setLocale(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLanguageCode, langCode);
    state = Locale(langCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Translations dictionary helper
class AppTranslations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'uz': {
      'app_title': 'TopSavdo',
      'tagline': "O'zbekistondagi №1 Savdo Maydonchasi",
      'home': 'Bosh sahifa',
      'favorites': 'Saralangan',
      'add_ad': "E'lon joylash",
      'messages': 'Xabarlar',
      'profile': 'Profil',
      'search_hint': "TopSavdodan istalgan narsani qidiring...",
      'categories': 'Kategoriyalar',
      'new_ads': "Yangi e'lonlar",
      'all': 'Barchasi',
      'language': 'Ilova tili',
      'theme_mode': 'Tungi rejim (Dark Mode)',
      'about': 'Ilova haqida (Info)',
      'contact': "Biz bilan bog'lanish (Contact)",
      'news': 'Yangiliklar va Blog',
      'admin_panel': 'Admin Panel',
      'add_comment': 'Sharh qoldirish',
      'comment_success': 'Siz yozgan sharh qabul qilindi',
    },
    'ru': {
      'app_title': 'TopSavdo',
      'tagline': 'Торговая площадка №1 в Узбекистане',
      'home': 'Главная',
      'favorites': 'Избранное',
      'add_ad': 'Подать объявление',
      'messages': 'Сообщения',
      'profile': 'Профиль',
      'search_hint': 'Ищите что угодно на TopSavdo...',
      'categories': 'Категории',
      'new_ads': 'Новые объявления',
      'all': 'Все',
      'language': 'Язык приложения',
      'theme_mode': 'Темный режим (Dark Mode)',
      'about': 'О приложении (Info)',
      'contact': 'Связаться с нами (Contact)',
      'news': 'Новости и Блог',
      'admin_panel': 'Панель администратора',
      'add_comment': 'Оставить отзыв',
      'comment_success': 'Ваш отзыв принят',
    },
    'en': {
      'app_title': 'TopSavdo',
      'tagline': '#1 Marketplace in Uzbekistan',
      'home': 'Home',
      'favorites': 'Favorites',
      'add_ad': 'Post Ad',
      'messages': 'Messages',
      'profile': 'Profile',
      'search_hint': 'Search anything on TopSavdo...',
      'categories': 'Categories',
      'new_ads': 'New Ads',
      'all': 'All',
      'language': 'App Language',
      'theme_mode': 'Dark Mode',
      'about': 'About App (Info)',
      'contact': 'Contact Us',
      'news': 'News & Blog',
      'admin_panel': 'Admin Panel',
      'add_comment': 'Add Comment',
      'comment_success': 'Your review has been accepted',
    },
  };

  static String translate(String key, String langCode) {
    return _localizedValues[langCode]?[key] ?? _localizedValues['uz']![key] ?? key;
  }
}

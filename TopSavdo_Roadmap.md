 # 🛒 TopSavdo — 0 dan Pro darajasigacha bosqichma-bosqich qurilish reja(y)i

> **Qanday ishlatiladi:** Har bir bosqich alohida "prompt" ko'rinishida yozilgan.
> Har safar bitta bosqichni AI kodlash yordamchisiga (Claude Code, Cursor, va h.k.) yoki o'zingizga vazifa qilib bering, tugagach keyingisiga o'ting. Oldingi bosqich ishlamasdan keyingisiga o'tmang — bu texnik qarzni oldini oladi.
>
> Loyiha holati: Flutter project yaratilgan ✅, Firebase ulangan ✅ → **1-etapdan boshlaymiz.**

---

## 📁 Umumiy loyiha strukturasi (maqsad)

```
lib/
├── core/            # constants, theme, utils, routes, extensions
├── models/          # ProductModel, UserModel, ChatModel, ReportModel...
├── services/        # auth_service, firestore_service, storage_service...
├── providers/        # yoki riverpod/bloc — state management
├── screens/
│   ├── auth/
│   ├── intro/
│   ├── home/
│   ├── search/
│   ├── product/
│   ├── add_product/
│   ├── favorites/
│   ├── my_ads/
│   ├── chat/
│   ├── profile/
│   └── admin/
├── widgets/         # umumiy reusable komponentlar
└── main.dart
```

**Tavsiya (pro daraja uchun):**
- State management: **Riverpod** (yoki Bloc, agar admin panel murakkablashsa)
- Routing: **go_router**
- Model → JSON: `freezed` + `json_serializable` (Firestore bilan ishlashni ancha osonlashtiradi)
- Linter: `flutter_lints` yoqilgan bo'lsin, `analysis_options.yaml` ni qattiqroq sozlang

---

## 0-ETAP — Fundament: papkalar, paketlar, theme

**Prompt:**
```
Flutter loyihamda quyidagi papka strukturasini yarat: core, models, services, providers,
screens (auth, intro, home, search, product, add_product, favorites, my_ads, chat, profile, admin),
widgets. pubspec.yaml ga quyidagi paketlarni qo'sh: firebase_core, firebase_auth, cloud_firestore,
firebase_storage, flutter_riverpod, go_router, easy_localization, shared_preferences,
cached_network_image, image_picker, freezed_annotation, json_annotation.
core/theme.dart faylida Light va Dark ThemeData yarat: asosiy rang, accent rang, font (Google Fonts
orqali), card style, button style — barchasi keyingi bosqichlarda qayta ishlatiladigan qilib.
```

**Tekshirish:** `flutter pub get` xatosiz o'tishi, ilova bo'sh ekranda ishga tushishi kerak.

---

## 1-ETAP — Modellar va Firestore sxemasi

**Prompt:**
```
models/ papkasida quyidagi modellarni freezed bilan yarat: UserModel (id, name, email, phone,
photoUrl, role: 'user'|'admin', rating, isTrusted, createdAt), ProductModel (id, title, price,
description, category, condition, images: List<String>, region, city, sellerId, sellerName,
sellerPhone, createdAt, status: 'active'|'pending'|'sold'), CategoryModel (id, name, icon),
FavoriteModel (userId, productId, createdAt), ChatModel (id, participants: List<String>,
productId, lastMessage, lastMessageTime), MessageModel (id, chatId, senderId, text, imageUrl,
createdAt, isRead), ReportModel (id, productId, reportedBy, reason, status, createdAt).
Har biriga fromJson/toJson yozib ber, Firestore Timestamp bilan to'g'ri ishlaydigan qilib.
```

**Tekshirish:** `build_runner` orqali `.freezed.dart` va `.g.dart` fayllar xatosiz generatsiya bo'lishi.

---

## 2-ETAP — Intro (onboarding) ekranlari

**Prompt:**
```
3 ta sahifali Intro (onboarding) ekran yarat, PageView asosida: (1) "TopSavdoga xush kelibsiz",
(2) "Mahsulotingizni soting", (3) "Xaridor bilan bog'laning". Har birida rasm/illyustratsiya
joyi, sarlavha, qisqa matn. Pastda dot indicator, "Skip" va "Keyingi"/"Boshlash" tugmalari.
SharedPreferences orqali 'intro_seen' flag saqla — ikkinchi ochilishda intro ko'rsatilmasin,
to'g'ridan-to'g'ri Login/Home ga yo'naltirilsin.
```

---

## 3-ETAP — Register / Login (Firebase Auth)

**Prompt:**
```
services/auth_service.dart yarat: Firebase Authentication orqali register (email+parol),
login, logout, forgot password (resetPasswordEmail) funksiyalarini yoz. Register muvaffaqiyatli
bo'lganda Firestore 'users' collectioniga UserModel yozilsin (role: 'user' default).
screens/auth/ ichida RegisterScreen (ism, email, telefon, parol, parolni tasdiqlash — validatsiya
bilan) va LoginScreen (email, parol, "Parolni unutdingizmi" link) yarat. Xatoliklarni foydalanuvchiga
tushunarli qilib ko'rsat (masalan "email band", "parol kamida 6 belgi" va h.k.).
```

**Tekshirish:** Yangi user Firebase Console'da Authentication va Firestore'da bir vaqtda paydo bo'lishi kerak.

---

## 4-ETAP — Home ekrani

**Prompt:**
```
HomeScreen yarat: yuqorida qidiruv paneli (bosilganda SearchScreen'ga o'tadi), keyin gorizontal
kategoriyalar ro'yxati (icon + nom), keyin "Yangi e'lonlar" sarlavhasi ostida GridView orqali
ProductCard'lar (rasm, nom, narx, joylashuv). Firestore'dan 'products' collectionini
status='active' bo'yicha, createdAt bo'yicha kamayish tartibida o'qi (dastlab 10 ta — pagination
keyingi bosqichda). Riverpod bilan state boshqar, loading/error holatlarini ko'rsat.
```

---

## 5-ETAP — Kategoriyalar

**Prompt:**
```
Firestore 'categories' collectioniga quyidagi statik ma'lumotlarni yozish uchun bir martalik
seed skript yoz (yoki admin panel orqali qo'shiladigan qilib qoldir): Avtomobil, Elektronika,
Kiyim, Uy, Ta'lim, Sport, Bolalar, Boshqa — har biriga mos icon bilan. HomeScreen'dagi kategoriya
bosilganda, o'sha kategoriyaga tegishli mahsulotlar ro'yxati ochiladigan CategoryProductsScreen yarat.
```

---

## 6-ETAP — Mahsulot tafsilotlari (Product Details)

**Prompt:**
```
ProductDetailsScreen yarat: yuqorida rasm carousel (PageView + indicator), nomi, narxi, manzili
(viloyat/shahar), holati (yangi/ishlatilgan), tavsifi, sotuvchi kartasi (rasm, ism, reyting,
"Ishonchli sotuvchi" belgisi agar isTrusted=true). Pastda 3 ta harakat: ❤️ Sevimliga qo'shish
(favorites collectioniga yoz/o'chir, real-time holatini kuzat), 💬 Xabar yozish (ChatScreen'ga
productId bilan o'tadi, agar chat mavjud bo'lmasa yangisini yaratadi), 📞 Qo'ng'iroq qilish
(url_launcher bilan tel: link). Yuqori burchakda "..." menyusida 🚨 Shikoyat qilish opsiyasi.
```

---

## 7-ETAP — E'lon berish (Add Product)

**Prompt:**
```
AddProductScreen yarat: image_picker orqali bir nechta rasm tanlash (max 5-8 ta, preview grid
+ o'chirish tugmasi), mahsulot nomi, kategoriya dropdown (Firestore'dan), narx (raqam formatter
bilan, masalan 4 500 000), holati (chip tanlov: Yangi/Ishlatilgan), tavsif (multiline), viloyat/
shahar dropdown (Uzbekiston viloyatlari statik list), telefon raqam (mask bilan). "E'lonni
joylashtirish" bosilganda: avval rasmlar Firebase Storage'ga yuklansin (progress indicator
bilan), keyin ProductModel Firestore'ga yozilsin (status: 'pending' agar moderatsiya bo'lsa,
aks holda 'active'). Muvaffaqiyatli bo'lsa Home yoki My Ads'ga qaytar.
```

---

## 8-ETAP — Firebase Storage integratsiyasi

**Prompt:**
```
services/storage_service.dart yarat: uploadProductImages(List<File> images, String userId,
String productId) funksiyasi — rasmlarni products/{userId}/{productId}/ papkasiga yuklaydi,
download URL'lar ro'yxatini qaytaradi. Rasm sifatini optimallash uchun yuklashdan oldin
image compression (masalan flutter_image_compress) qo'sh. Xatolik holatlarini (internet yo'q,
fayl juda katta) to'g'ri ushlab, foydalanuvchiga xabar ber.
```

---

## 9-ETAP — Firestore xavfsizlik qoidalari (Security Rules)

**Prompt:**
```
Firestore Security Rules yoz: users — faqat o'ziniki o'qish/yozish mumkin (admin hammasini
o'qiy oladi), products — hamma o'qiy oladi, faqat egasi yoki admin yoza/o'chira oladi
(status='pending'dan 'active'ga faqat admin o'zgartira oladi), favorites/chats/messages —
faqat tegishli foydalanuvchi(lar) kira oladi, reports — hamma yoza oladi, faqat admin o'qiy/
o'zgartira oladi. Buni firestore.rules faylida yoz va qanday deploy qilishni tushuntir.
```

**Muhim:** Bu bosqichni kechiktirmang — production'ga chiqmasdan oldin albatta bo'lishi shart, aks holda har kim ma'lumotlaringizni o'qiy/yoza oladi.

---

## 10-ETAP — Mening e'lonlarim (My Ads)

**Prompt:**
```
MyAdsScreen yarat: joriy foydalanuvchining sellerId bo'yicha barcha mahsulotlarini status
bo'yicha tab'larga bo'lib ko'rsat (🟢 Aktiv, 🟡 Tekshirilmoqda, 🔴 Sotilgan). Har bir kartada
Tahrirlash, O'chirish, "Sotilgan deb belgilash" tugmalari bo'lsin. O'chirishda tasdiqlash
dialogi chiqsin, o'chirishda Storage'dagi rasmlar ham o'chirilsin.
```

---

## 11-ETAP — Mahsulotni tahrirlash (Edit Product)

**Prompt:**
```
EditProductScreen yarat — AddProductScreen bilan bir xil forma, lekin mavjud ma'lumotlar bilan
oldindan to'ldirilgan. Foydalanuvchi yangi rasm qo'shishi, eskisini o'chirishi, narx/tavsif/
holatni o'zgartirishi mumkin. Saqlashda faqat o'zgargan maydonlarni Firestore'da yangila
(updatedAt bilan birga).
```

---

## 12-ETAP — Sevimlilar (Favorites)

**Prompt:**
```
FavoritesScreen yarat: joriy foydalanuvchining favorites collectionidagi productId'lar bo'yicha
mahsulotlarni GridView'da ko'rsat. Har bir kartada ❤️ bosilsa sevimlilardan o'chirilsin (optimistic
UI — darhol ekrandan yo'qolsin, keyin Firestore'ga yozilsin). Bo'sh bo'lsa "Hali sevimli
mahsulotlaringiz yo'q" holatini ko'rsat.
```

---

## 13-ETAP — Qidiruv va Filter (Search)

**Prompt:**
```
SearchScreen yarat: yuqorida qidiruv input (debounce 400ms bilan), pastda natijalar GridView.
Firestore'da to'liq matnli qidiruv yo'qligi sabab, title_lowercase maydonini har bir mahsulotga
qo'shib, arrayContains yoki prefix-qidiruv (where isGreaterThanOrEqualTo/isLessThan) orqali
qidiruvni amalga oshir (yoki Algolia/Meilisearch integratsiyasini taklif qil, agar loyiha
kattalashsa). Filter paneli qo'sh: narx oralig'i (RangeSlider), kategoriya, hudud, holati.
Sort opsiyalari: Yangi, Arzon→qimmat, Qimmat→arzon.
```

---

## 14-ETAP — Pagination

**Prompt:**
```
Home va Search ekranlaridagi mahsulot ro'yxatlariga infinite scroll pagination qo'sh: Firestore
query'da limit(10) va startAfterDocument(lastDoc) ishlatib, ScrollController orqali pastga
tushganda keyingi 10 tani yukla. Yuklanayotgan payt pastda kichik loading indicator ko'rsat,
ma'lumot tugaganda "Boshqa mahsulot yo'q" xabarini chiqar.
```

---

## 15-ETAP — Chat (real-time)

**Prompt:**
```
services/chat_service.dart yarat: createOrGetChat(productId, buyerId, sellerId), sendMessage(
chatId, text/imageUrl), streamMessages(chatId) — Firestore snapshot listener orqali real-time.
ChatScreen yarat: xabarlar ro'yxati (o'zi yuborgan/qabul qilgan turlicha stil bilan bubble),
pastda text input + rasm yuborish tugmasi + jo'natish tugmasi. Xabar yuborilganda chat
hujjatidagi lastMessage/lastMessageTime yangilansin.
```

---

## 16-ETAP — Chat ro'yxati

**Prompt:**
```
ChatListScreen yarat: joriy foydalanuvchi ishtirok etgan barcha chatlarni lastMessageTime
bo'yicha tartiblab ko'rsat. Har bir qatorda: suhbatdosh rasmi/ismi, tegishli mahsulot nomi
(kichik thumbnail bilan), oxirgi xabar matni, vaqt, o'qilmagan xabarlar soni (badge). Real-time
stream orqali yangi xabar kelganda ro'yxat avtomatik yangilansin.
```

---

## 17-ETAP — Profil

**Prompt:**
```
ProfileScreen yarat: profil rasmi (image_picker orqali o'zgartirish), ism, reyting yulduzchalar
bilan, keyin menyu qatorlari: Mening e'lonlarim, Sevimlilar, Chatlar, Sozlamalar, Chiqish
(logout tasdiqlash bilan). Agar user role='admin' bo'lsa, qo'shimcha "Admin Panel" qatori
ko'rinsin.
```

---

## 18-ETAP — Sozlamalar (Settings)

**Prompt:**
```
SettingsScreen yarat: 🌙 Dark Mode toggle (Riverpod orqali ThemeMode boshqar, SharedPreferences'da
saqla), 🌍 Til tanlash (easy_localization orqali uz/ru/en), 🔔 Bildirishnomalar on/off toggle,
🔐 Parolni o'zgartirish (eski parol + yangi parol, Firebase reauthenticate + updatePassword).
```

---

## 19-ETAP — EasyLocalization (3 til)

**Prompt:**
```
assets/translations/ papkasida uz.json, ru.json, en.json fayllarini yarat. Ilovadagi barcha
matnlarni (tugmalar, sarlavhalar, xato xabarlari) shu fayllarga ko'chir va kodda .tr() orqali
chaqir. main.dart'da EasyLocalization widget bilan o'ra, qo'llab-quvvatlanadigan tillarni
sozla. Settings ekranidagi til tanlovi bilan bog'la.
```

---

## 20-ETAP — Dark Mode to'liq moslashtirish

**Prompt:**
```
Barcha ekranlarni ko'zdan kechir: qattiq kodlangan (hardcoded) ranglar (masalan Colors.white,
Colors.black) bor joylarini top va Theme.of(context).colorScheme dan foydalanadigan qilib
almashtir. Dark rejimda kontrastni, rasm fonlarini va card soyalarini tekshir.
```

---

## 21-ETAP — Shikoyat qilish (Report)

**Prompt:**
```
ReportDialog widget yarat: sabablar ro'yxati (radio button) — Soxta mahsulot, Noto'g'ri
ma'lumot, Shubhali sotuvchi, Boshqa (bo'lsa qo'shimcha izoh maydoni). Yuborilganda ReportModel
Firestore 'reports' collectioniga yoziladi (status: 'pending'). Product Details ekranidagi
"..." menyusidan chaqiriladi.
```

---

## 22-ETAP — Ishonchli sotuvchi (Trusted seller) va reyting

**Prompt:**
```
Sotuvchi reytingini hisoblash mantig'ini yoz: xaridorlar sotuvchiga baho berishi mumkin bo'lgan
oddiy rating tizimi (masalan chat yopilgach yoki alohida "Sotuvchini baholash" tugmasi orqali).
UserModel'dagi rating va isTrusted maydonlarini shu asosda yangila (masalan reyting >= 4.5 va
20+ ta sotilgan e'lon bo'lsa isTrusted=true). Product Details va Chat ekranlarida sotuvchi
ismi yonida "✓ Ishonchli sotuvchi" belgisini ko'rsat.
```

---

## 23–24-ETAP — Admin Panel va Admin Login

**Prompt:**
```
screens/admin/ ichida AdminDashboardScreen (statistika kartalar: jami userlar, jami e'lonlar,
kutilayotgan shikoyatlar), AdminUsersScreen (userlar ro'yxati, bloklash/o'chirish),
AdminProductsScreen (e'lonlar ro'yxati, status='pending' bo'lganlarni tasdiqlash/rad etish,
o'chirish), AdminReportsScreen (shikoyatlarni ko'rish, tekshirish, tegishli e'lonni o'chirish)
yarat. Login ekranida foydalanuvchi login qilganda Firestore'dan role o'qilsin: agar
role='admin' bo'lsa AdminDashboard'ga, aks holda oddiy Home'ga yo'naltirilsin.
```

**Muhim:** Admin huquqlari faqat Firestore Security Rules darajasida ham tekshirilishi kerak (frontend tekshiruvi yetarli emas).

---

## 25-ETAP — Bildirishnomalar (FCM)

**Prompt:**
```
Firebase Cloud Messaging integratsiyasini qo'sh: services/notification_service.dart yarat,
FCM token'ni foydalanuvchi hujjatiga saqla. Cloud Functions orqali (yoki keyinroq backend
qo'shilsa) quyidagi hodisalarda push yuborilsin: "Sizning e'loningiz tasdiqlandi", "Sizga
yangi xabar keldi". Foreground/background/terminated holatlarda notification'larni to'g'ri
qabul qilish va bosilganda tegishli ekranga yo'naltirishni sozla.
```

---

## 26–27-ETAP — Loading, Error va Internet holatlari

**Prompt:**
```
core/ ichida umumiy widget'lar yarat: LoadingWidget (shimmer yoki spinner), ErrorStateWidget
(xato matni + "Qayta urinish" tugmasi), EmptyStateWidget ("Mahsulot topilmadi" kabi holatlar
uchun). connectivity_plus paketini qo'shib, internet yo'qligida butun ilova ustida
"⚠️ Internet aloqasi mavjud emas" banner ko'rsatadigan global listener yoz.
```

---

## 28-ETAP — GitHub

**Prompt:**
```
.gitignore faylini Flutter uchun to'g'ri sozla (build/, .dart_tool/, firebase_options.dart
maxfiy bo'lsa alohida qara). Quyidagi tartibda mantiqiy commitlar bilan tarixni tuzuklashtir
(agar hali qilinmagan bo'lsa, bundan keyingi ishlarni shu tartibda commit qil): Initial
project, Added intro, Added authentication, Added home, Added product details, Added Firebase,
Added add product, Added search, Added favorites, Added chat, Added admin panel, Added
localization, Added dark mode, Final version. README.md ga loyiha tavsifi, screenshot'lar,
o'rnatish yo'riqnomasini yoz.
```

---

## 29-ETAP — Test qilish

**Prompt:**
```
Quyidagi funksional test checklist bo'yicha qo'lda sinovdan o'tkaz (keyinchalik widget/
integration testlar bilan avtomatlashtirish mumkin): Register/Login/Logout/Forgot Password,
Home (scroll, kategoriya, mahsulot ochish), Search+Filter+Pagination, E'lon berish (rasm
yuklash, saqlash), Edit/Delete e'lon, Chat (xabar yuborish/qabul qilish, real-time),
Profil/Dark Mode/Til almashtirish, Admin (login, userlarni boshqarish, e'lonlarni tasdiqlash,
shikoyatlarni ko'rish). Har bir band uchun ✅/❌ belgilab, topilgan xatolarni alohida ro'yxat
qilib ol.
```

---

## 30-ETAP — Yakuniy dizayn siyqallashtirish (polish)

**Prompt:**
```
Butun ilova bo'ylab: tugmalar, iconlar, fontlar, ranglar, card'lar, spacing (padding/margin)
bir xil uslubga keltirilsinmi tekshir. Barcha ekranlarga mos loading/error/empty holatlar
qo'yilganini tasdiqla. Asosiy harakatlarga (like bosish, chat ochish, e'lon joylash) sodda
animatsiyalar (masalan AnimatedContainer, Hero animation rasm ochishda) qo'sh. App icon va
splash screen'ni flutter_launcher_icons / flutter_native_splash paketlari orqali sozla.
```

---

## 🎯 Pro darajaga ko'tarish uchun qo'shimcha g'oyalar (MVP'dan keyin)

- **Backend ko'chirish:** Firestore o'rniga (yoki qo'shimcha) Cloud Functions bilan biznes mantiqni serverga chiqarish (masalan reyting hisoblash, moderatsiya)
- **To'lov integratsiyasi:** Click/Payme orqali "Premium e'lon" (yuqoriroqda ko'rsatish) funksiyasi
- **Xarita:** Google Maps/Yandex Maps orqali mahsulot joylashuvini xaritada ko'rsatish
- **Analytics:** Firebase Analytics + Crashlytics — foydalanuvchi xatti-harakatini va xatolarni kuzatish
- **CI/CD:** GitHub Actions orqali avtomatik build va test
- **Store'ga chiqarish:** Google Play Console (ichki test → yopiq test → production), keyin App Store

---

### 📌 Ishlatish tartibi eslatmasi
1-etapdan boshlab ketma-ket boring, har birini "Tekshirish" bandi bo'yicha tasdiqlang, so'ng keyingisiga o'ting. Agar bir bosqichda AI yordamchi noto'g'ri kod yozsa, o'sha bosqich promptini aniqlashtirib (masalan "Riverpod StateNotifier bilan yoz", "GetX emas, provider bilan" kabi) qayta bering.

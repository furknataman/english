import 'package:english/pages/about.dart';
import 'package:english/pages/list.dart';
import 'package:english/pages/multiple_choice.dart';
import 'package:english/pages/settings.dart';
import 'package:english/pages/support_page.dart';
import 'package:english/pages/words_card.dart';
import 'package:english/provider/word_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../core/app_icons.dart';
import '../../db/db/shared_preferences.dart';
import '../../global_variable.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

final dashboardInfoProvider = ChangeNotifierProvider((ref) => InfoProvider());

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _DashboardTab(onNavigate: (i) => setState(() => _currentIndex = i)),
          const ListPage(isTab: true),
          _StudyTab(),
          const SettingsPage(isTab: true),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.borderDark, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surfaceDark,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiaryDark,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Ana Sayfa'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Listeler'),
            BottomNavigationBarItem(icon: Icon(Icons.bolt_rounded), label: 'Çalış'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Ayarlar'),
          ],
        ),
      ),
    );
  }
}

// ─── Tab 0: Dashboard ────────────────────────────────────────
class _DashboardTab extends ConsumerStatefulWidget {
  final void Function(int) onNavigate;
  const _DashboardTab({required this.onNavigate});

  @override
  ConsumerState<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<_DashboardTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(dashboardInfoProvider).getCounter());
  }

  @override
  Widget build(BuildContext context) {
    final info = ref.watch<InfoProvider>(dashboardInfoProvider);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),

            // Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Image.asset("assets/images/logo.png", width: 28, height: 28),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      "VocApp",
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _LanguageToggle(),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AbaoutPage())),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: AppSpacing.borderRadiusSm,
                          border: Border.all(color: AppColors.borderDark),
                        ),
                        child: Center(
                          child: AppIcons.svg(AppIcons.circleInfo, size: 18, color: AppColors.textSecondaryDark),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Greeting
            Text("Merhaba!", style: AppTypography.displayLarge.copyWith(color: AppColors.textPrimaryDark)),
            const SizedBox(height: AppSpacing.xs),
            Text("Bugün ne öğrenmek istersin?", style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondaryDark)),

            const SizedBox(height: AppSpacing.xxl),

            // Stats
            Row(
              children: [
                Expanded(child: _StatCard(icon: AppIcons.book, iconColor: AppColors.primary, value: info.totalWord.toString(), label: "Toplam Kelime")),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _StatCard(icon: AppIcons.circleCheck, iconColor: AppColors.success, value: info.learnedWord.toString(), label: "Öğrenilen")),
              ],
            ),

            const SizedBox(height: AppSpacing.xxxl),

            Text("HIZLI ERİŞİM", style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiaryDark, letterSpacing: 1.2)),
            const SizedBox(height: AppSpacing.lg),

            // Quick access
            _QuickAccessItem(
              icon: AppIcons.book, title: "Listelerim", subtitle: "Koleksiyonlarını yönet ve düzenle",
              onTap: () => widget.onNavigate(1),
            ),
            const SizedBox(height: AppSpacing.md),
            _QuickAccessItem(
              icon: AppIcons.creditCard, title: "Flashcard", subtitle: "Görsel hafıza ile hızlı tekrar yap",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WordCardspage())),
            ),
            const SizedBox(height: AppSpacing.md),
            _QuickAccessItem(
              icon: AppIcons.clockRotateLeft, title: "Quiz", subtitle: "Bilgini test et ve seviye atla",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MultipleChoicePage())),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Bizi Destekle
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: AppSpacing.borderRadiusMd,
                  boxShadow: [BoxShadow(color: AppColors.gold.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    AppIcons.svg(AppIcons.heart, size: 22, color: Colors.white),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: Text("Bizi Destekle", style: AppTypography.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
                    AppIcons.svg(AppIcons.chevronRight, size: 16, color: Colors.white70),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

// ─── Tab 2: Study selector ───────────────────────────────────
class _StudyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text("Çalış", style: AppTypography.displayMedium.copyWith(color: AppColors.textPrimaryDark)),
            const SizedBox(height: AppSpacing.xs),
            Text("Bir çalışma modu seç", style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondaryDark)),
            const SizedBox(height: AppSpacing.xxxl),

            _QuickAccessItem(
              icon: AppIcons.creditCard,
              title: "Flashcard",
              subtitle: "Kartları çevirerek kelimeleri öğren",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WordCardspage())),
            ),
            const SizedBox(height: AppSpacing.lg),
            _QuickAccessItem(
              icon: AppIcons.clockRotateLeft,
              title: "Quiz",
              subtitle: "Çoktan seçmeli sorularla kendini test et",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MultipleChoicePage())),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared widgets ──────────────────────────────────────────
class _LanguageToggle extends StatefulWidget {
  @override
  State<_LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<_LanguageToggle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (chooeseLang == Lang.eng) {
            chooeseLang = Lang.tr;
            SP.write("lang", false);
          } else {
            chooeseLang = Lang.eng;
            SP.write("lang", true);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppSpacing.borderRadiusSm,
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Text(
          chooeseLang == Lang.tr ? "TR" : "EN",
          style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.iconColor, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: AppSpacing.borderRadiusSm),
            child: Center(child: AppIcons.svg(icon, size: 20, color: iconColor)),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: AppTypography.displayMedium.copyWith(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _QuickAccessItem({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.borderDark, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: AppSpacing.borderRadiusSm),
              child: Center(child: AppIcons.svg(icon, size: 22, color: AppColors.primary)),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                ],
              ),
            ),
            AppIcons.svg(AppIcons.chevronRight, size: 16, color: AppColors.textTertiaryDark),
          ],
        ),
      ),
    );
  }
}

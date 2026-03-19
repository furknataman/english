import 'package:english/db/db/default_word.dart';
import 'package:english/global_variable.dart';
import 'package:english/pages/main_page/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_spacing.dart';
import '../core/review_helper.dart';
import '../db/db/shared_preferences.dart';

class TemproryPage extends StatefulWidget {
  const TemproryPage({Key? key}) : super(key: key);

  @override
  State<TemproryPage> createState() => _TemproryPageState();
}

class _TemproryPageState extends State<TemproryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    });
    sPRead();
    setFiravase();
    defaultWord();
    ReviewHelper.incrementAndCheck();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void setFiravase() async {
    await Firebase.initializeApp();
  }

  void sPRead() async {
    if (await SP.read('lang') == true) {
      chooeseLang = Lang.eng;
    } else {
      chooeseLang = Lang.tr;
    }
    switch (await SP.read("which")) {
      case 0:
        chooseQuwstionType = Which.learned;
        break;
      case 1:
        chooseQuwstionType = Which.unlearned;
        break;
      case 2:
        chooseQuwstionType = Which.all;
        break;
    }
    if (await SP.read('mix') == false) {
      listMixed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Logo
              ColorFiltered(
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                child: Image.asset("assets/images/logo.png", width: 120),
              ),
              const SizedBox(height: AppSpacing.xxl),
              // App name
              Text(
                "VocApp",
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontSize: 38,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Subtitle
              Text(
                "İngilizce Kelime Öğrenme",
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondaryDark,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(flex: 3),
              // Loading indicator
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primary.withValues(alpha: 0.7)),
                ),
              ),
              const SizedBox(height: AppSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }
}

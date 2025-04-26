import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:daleel/screens/main_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingInfo {
  final String title;
  final String description;
  final IconData icon; 

  OnboardingInfo({required this.title, required this.description, required this.icon});
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingInfo> _onboardingPages = [
    OnboardingInfo(
      title: 'استكشف كل شبرٍ من الحرم الجامعي', 
      description: 'خرائطٌ مفصّلة ودقيقة للمباني والمرافق على هاتفك', 
      icon: Icons.map_rounded,
    ),
    OnboardingInfo(
      title: 'توجّه مع الواقع المعزّز!', 
      description: 'تجربة ملاحةٍ غامرة، استكشف طريقك في بيئتك الواقعيّة', 
      icon: Icons.view_in_ar_rounded,
    ),
    OnboardingInfo(
      title: 'صمّم خصّيصًا لذوي الإعاقة البصريّة', 
      description: 'نظامٌ صوتيٌّ دقيقٌ يوجّهك، ودعمٌ كامل للتقنيات المساعدة', 
      icon: Icons.record_voice_over, 
    ),
    OnboardingInfo(
      title: 'جاهز للسير في الجامعة؟', 
      description: 'ابدأ رحلتك الآن مع دليل!', 
      icon: Icons.navigation_rounded,
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skipOnboarding() {
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainLayout()), 
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _startApp() {
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainLayout()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isLastPage = _currentPage == _onboardingPages.length - 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), 
            child: TextButton(
              onPressed: _skipOnboarding,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, 
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.skipButton, 
                style: theme.textTheme.bodyLarge?.copyWith( 
                   color: theme.colorScheme.onSurface.withOpacity(0.7),
                 ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingPages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final page = _onboardingPages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        page.icon,
                        size: 120,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        page.description,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _onboardingPages.length,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: theme.primaryColor,
                dotColor: theme.colorScheme.secondary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 30),
             
            SizedBox(
              height: 60, 
              child: Stack(
                alignment: Alignment.center, 
                children: [
                   
                  if (_currentPage > 0)
                     Positioned(
                      right: 16, 
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new), 
                        color: theme.primaryColor,
                        tooltip: 'السابق', 
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                      ),
                    ),

                  
                  Center(
                    child: isLastPage
                        ? ElevatedButton(
                            onPressed: _startApp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            child: const Text('ابدأ الآن'), 
                          )
                        : ElevatedButton(
                            onPressed: _nextPage,
                             style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            child: const Text('التالي'), 
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:fradel_spies/providers/auth_provider.dart';
import 'package:fradel_spies/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _pageIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageController,
                children: const <Widget>[
                  Center(
                    child: Image(
                      image: AssetImage('assets/onboarding_one.png'),
                    ),
                  ),
                  Center(
                    child: Image(
                      image: AssetImage('assets/onboarding_two.png'),
                    ),
                  ),
                  Center(
                    child: Image(
                      image: AssetImage('assets/onboarding_three.png'),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF231F20),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(36),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          [
                            'Praktis dan Efisien',
                            'Banyak Pilihan',
                            'Layanan Super Cepat dan Mudah!',
                          ].elementAt(_pageIndex),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFBFBFB),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24, left: 48, right: 48),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          [
                            'Praktis tanpa ribet! Hemat waktu dan tenaga dengan berbelanja online',
                            'Ribuan produk, satu aplikasi! Pilihan lengkap untuk semua kebutuhan Anda.',
                            'Pengalaman belanja tanpa hambatan, hanya dengan beberapa klik.'
                          ].elementAt(_pageIndex),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFDBD5D5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 54,
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          if (_pageIndex < 2) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          } else {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChangeNotifierProvider(
                                          create: (_) => AuthProvider(),
                                          child: const AuthScreen(),
                                        )),
                                (_) => false);
                          }
                        },
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Berikutnya',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Sudah punya akun?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChangeNotifierProvider(
                                          create: (_) => AuthProvider(),
                                          child: const AuthScreen(),
                                        )),
                                (_) => false);
                          },
                          child: const Text('Masuk'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Impor semua Provider yang digunakan
import 'package:fradel_spies/providers/auth_provider.dart';
import 'package:fradel_spies/providers/base_provider.dart';
import 'package:fradel_spies/providers/home_provider.dart';
import 'package:fradel_spies/providers/user_provider.dart';
import 'package:fradel_spies/providers/my_shop_provider.dart'; // Impor UserProvider

// Impor semua Screen yang digunakan
import 'package:fradel_spies/screens/auth_screen.dart';
import 'package:fradel_spies/screens/home_screen.dart';
import 'package:fradel_spies/screens/splash_screen.dart';

// Kunci global untuk navigasi
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const String image =
    'https://e3.365dm.com/19/09/1600x900/skynews-drew-scanlon-blinking-white-guy_4786055.jpg?20190925134801';
const String mobileAppVersion = '0.0.0';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BaseProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (_) => UserProvider()), // Daftarkan UserProvider
        ChangeNotifierProvider(create: (_) => MyShopProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fradel & Spies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.orange,
        fontFamily: 'Poppins',
      ),
      navigatorKey: navigatorKey,
      home: const BaseScreen(),
    );
  }
}

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BaseProvider>().init().whenComplete(() {
        final String? bearerToken = context.read<BaseProvider>().bearerToken;
        final bool hasToken = bearerToken != null && bearerToken.isNotEmpty;

        if (hasToken) {
          Navigator.pushAndRemoveUntil(
            context, // Menggunakan context langsung dari widget
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => HomeProvider()..init(),
                child: const HomeScreen(),
              ),
            ),
            (_) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context, // Menggunakan context langsung dari widget
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (_) => false,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AuthGateWidget extends StatefulWidget {
  const AuthGateWidget({super.key});

  @override
  State<AuthGateWidget> createState() => _AuthGateWidgetState();
}

class _AuthGateWidgetState extends State<AuthGateWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<BaseProvider>().init());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: context.watch<BaseProvider>().bearerToken == null
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : context.watch<BaseProvider>().bearerToken!.isNotEmpty
              ? const HomeScreen()
              : ChangeNotifierProvider(
                  create: (_) => AuthProvider(),
                  child: const AuthScreen(),
                ),
    );
  }
}

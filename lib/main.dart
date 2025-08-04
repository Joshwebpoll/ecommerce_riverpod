import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/app_theme/app_themes.dart';
import 'package:riverpod_ecommerce/models/category_model.dart';
import 'package:riverpod_ecommerce/models/product_model.dart';
import 'package:riverpod_ecommerce/models/user_model.dart';
import 'package:riverpod_ecommerce/screens/cart_screen.dart';
import 'package:riverpod_ecommerce/screens/email_verification_screen.dart';
import 'package:riverpod_ecommerce/screens/home_screen.dart';
import 'package:riverpod_ecommerce/screens/login_screen.dart';
import 'package:riverpod_ecommerce/screens/onboarding_screen.dart';
import 'package:riverpod_ecommerce/screens/product_category.dart';
import 'package:riverpod_ecommerce/screens/profile_screen.dart.dart';
import 'package:riverpod_ecommerce/screens/reset_password_otp_screen.dart';
import 'package:riverpod_ecommerce/screens/reset_password_screen.dart';
import 'package:riverpod_ecommerce/screens/signup_screen.dart';
import 'package:riverpod_ecommerce/services/auth_service.dart';
import 'package:riverpod_ecommerce/screens/product_details.dart';
import 'package:riverpod_ecommerce/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  final authRes = AuthService();
  final user = await UserService().checkUser();

  final isLoggedIn = await authRes.isLoggedIn();
  final isOnboarded = await authRes.isOnboarded();
  // final isLoggedIn = prefs.getString('token') ;

  runApp(
    ProviderScope(
      child: MyApp(
        initialRoute:
            user
                ? '/home'
                : isOnboarded
                ? '/'
                : '/onboarding',
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      // This is the theme of your application.
      //
      // TRY THIS: Try running your application with "flutter run". You'll see
      // the application has a purple toolbar. Then, without quitting the app,
      // try changing the seedColor in the colorScheme below to Colors.green
      // and then invoke "hot reload" (save your changes or press the "hot
      // reload" button in a Flutter-supported IDE, or press "r" if you used
      // the command line to start the app).
      //
      // Notice that the counter didn't reset back to zero; the application
      // state is not lost during the reload. To reset the state, use hot
      // restart instead.
      //
      // This works for code too, not just values: Most code changes can be
      // tested with just a hot reload.
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/profile':
            final user = settings.arguments as UserModel;
            return MaterialPageRoute(builder: (_) => ProfileScreen(user: user));
          case '/onboarding':
            return MaterialPageRoute(builder: (_) => OnboardingScreen());
          case '/verify':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => EmailOtpScreen(email: args['email']),
            );
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());
          case '/password_otp':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ResetPasswordOtpScreen(email: args['email']),
            );

          case '/product_details':
            final prod = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (_) => ProductDetails(prod: prod),
            );
          case '/reset':
            return MaterialPageRoute(
              builder: (_) => const ResetPasswordScreen(),
            );
          case '/product_categories':
            final cat = settings.arguments as Category;
            return MaterialPageRoute(builder: (_) => ProductCategory(cat: cat));
          case '/cart_screen':
            return MaterialPageRoute(builder: (_) => CartScreen());
          default:
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(child: Text('404 Not Found')),
                  ),
            );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui/screens/main_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: NiCeMusicApp(),
    ),
  );
}

class NiCeMusicApp extends StatelessWidget {
  const NiCeMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData darkTheme = ThemeData.dark(useMaterial3: true);

    return MaterialApp(
      title: 'NiCe Music',
      debugShowCheckedModeBanner: false,
      theme: darkTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: const Color(0xFF1DB954),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DB954),
          surface: Color(0xFF0F0F0F),
          onSurface: Color(0xFFFFFFFF),
          secondary: Color(0xFFB3B3B3),
        ),
        textTheme: GoogleFonts.interTextTheme(darkTheme.textTheme).apply(
          bodyColor: const Color(0xFFFFFFFF),
          displayColor: const Color(0xFFFFFFFF),
        ),
      ),
      home: const MainScaffold(),
    );
  }
}

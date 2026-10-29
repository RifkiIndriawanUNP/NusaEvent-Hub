import 'package:flutter/material.dart';
import 'screens/home_events_screen.dart';

// Satu warna aksen untuk tab terpilih dan semua tombol.
const Color kAccent = Color(0xFF7C5CFF);
const Color kBackground = Color(0xFF070B14);

void main() => runApp(const NusaEventApp());

class NusaEventApp extends StatelessWidget {
  const NusaEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
    return MaterialApp(
      title: 'NusaEvent Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
                seedColor: kAccent, brightness: Brightness.dark)
            .copyWith(primary: kAccent, onPrimary: Colors.white),
        scaffoldBackgroundColor: kBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              backgroundColor: kAccent, foregroundColor: Colors.white, shape: shape),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              backgroundColor: kAccent,
              foregroundColor: Colors.white,
              side: BorderSide.none,
              shape: shape),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: kAccent, foregroundColor: Colors.white, shape: shape),
        ),
        chipTheme: const ChipThemeData(
          selectedColor: kAccent,
          checkmarkColor: Colors.white,
        ),
      ),
      home: const HomeEventsScreen(),
    );
  }
}
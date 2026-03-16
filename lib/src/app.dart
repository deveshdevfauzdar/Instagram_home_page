import 'package:flutter/material.dart';

import 'features/feed/presentation/screens/feed_screen.dart';

class InstagramFeedApp extends StatelessWidget {
  const InstagramFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Pixel Feed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFAFAFA),
          surface: Color(0xFF000000),
          onSurface: Color(0xFFFAFAFA),
          onPrimary: Color(0xFF000000),
        ),
        dividerColor: const Color(0xFF262626),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          foregroundColor: Color(0xFFFAFAFA),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const FeedScreen(),
    );
  }
}

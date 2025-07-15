import 'package:flutter/material.dart';

// Light Theme Colors
const lightBg = Color(0xFFF5F5F5);
const lightText = Color(0xFF333333);
const lightTextSecondary = Color(0xB3333333); // 70% opacity
const lightAccent = Color(0xFF2A8CF4);
const lightAccentSecondary = Color(0xFFFF3A8C);
const lightAccentTertiary = Color(0xFF00C2FF);
const lightCardBg = Color(0xE6FFFFFF); // 90% opacity
const lightCardBorder = Color(0x1A000000); // 10% opacity
const lightScrolledHeaderBg = Color(0xCCFFFFFF); // 80% opacity
const lightHeaderShadow = Color(0x26000000); // 15% opacity
const lightFooterBg = Color(0xE6FFFFFF); // 90% opacity

// Dark Theme Colors
const darkBg = Color(0xFF0A0A0A);
const darkText = Color(0xFFF0F0F0);
const darkTextSecondary = Color(0xB3FFFFFF); // 70% opacity
const darkAccent = Color(0xFF4D6BFF);
const darkAccentSecondary = Color(0xFFFF3C9E);
const darkAccentTertiary = Color(0xFF00B2E5);
const darkCardBg = Color(0xE6141414); // 90% opacity
const darkCardBorder = Color(0x0FFFFFFF); // 6% opacity
const darkScrolledHeaderBg = Color(0xE60F0F0F); // 90% opacity
const darkHeaderShadow = Color(0x14FFFFFF); // 8% opacity
const darkFooterBg = Color(0xE6141414); // 85% opacity

// Gradients
const lightPrimaryButtonGradient = LinearGradient(
  colors: [Color(0xFFA18DFF), Color(0xFF7D5FFF)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const lightSecondaryButtonGradient = LinearGradient(
  colors: [Color(0xFFFF3A8C), Color(0xFFFF6B6B)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const lightHeroGradient = LinearGradient(
  colors: [Color(0xFF4D6BFF), Color(0xFF863AE0), Color(0xFFFF3C9E), Color(0xFFFF2673)],
  stops: [0.0, 0.25, 0.7, 1.0],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const darkPrimaryButtonGradient = LinearGradient(
  colors: [Color(0xFF8F78E5), Color(0xFF6544DD)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const darkSecondaryButtonGradient = LinearGradient(
  colors: [Color(0xFFCC2F7D), Color(0xFFCC3C57)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const darkHeroGradient = LinearGradient(
  colors: [Color(0xFF3A54CC), Color(0xFF6B2BB3), Color(0xFFCC2F7D), Color(0xFFCC1F5D)],
  stops: [0.0, 0.25, 0.7, 1.0],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ThemeData Configurations
final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: lightBg,
  primaryColor: lightAccent,
  cardColor: lightCardBg,
  dividerColor: lightCardBorder,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      color: lightText,
    ),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkBg,
  primaryColor: darkAccent,
  cardColor: darkCardBg,
  dividerColor: darkCardBorder,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: darkText,
    titleTextStyle: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: darkText,
    ),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      color: darkText,
    ),
  ),
);
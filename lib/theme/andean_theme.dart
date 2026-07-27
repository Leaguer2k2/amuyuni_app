import 'package:flutter/material.dart';

class AndeanColors {
  static const primary = Color(0xFFFF5722);
  static const primaryDark = Color(0xFFC41C00);
  static const secondary = Color(0xFF3A1C71);
  static const secondaryLight = Color(0xFFD76D77);
  static const accent = Color(0xFF00E5FF);
  static const gold = Color(0xFFFFD600);
  static const success = Color(0xFF00C853);
  static const successDark = Color(0xFF009624);
  static const background = Color(0xFFF9F6F0);
  static const surface = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF1B0A2E);
  static const textLight = Color(0xFFFFFFFF);
  static const greyCool = Color(0xFF9E9E9E);
  static const redAlert = Color(0xFFFF1744);
  static const redAlertDark = Color(0xFFC5111B);
  static const orangeAlert = Color(0xFFFF9100);

  static const headerGradient = LinearGradient(
    colors: [Color(0xFF3A1C71), Color(0xFFD76D77), Color(0xFFFF5722)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const headerDarkGradient = LinearGradient(
    colors: [Color(0xFF1B0A2E), Color(0xFF3A1C71)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const alertGradient = LinearGradient(
    colors: [Color(0xFFFF1744), Color(0xFFFF9100)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const goldGradient = LinearGradient(
    colors: [Color(0xFFFFD600), Color(0xFFFF9100)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const successGradient = LinearGradient(
    colors: [Color(0xFF00C853), Color(0xFF00E676)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardShadow = [
    BoxShadow(
      color: Color(0x1A3A1C71),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const buttonShadow = [
    BoxShadow(
      color: Color(0x663A1C71),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const glowShadowOrange = [
    BoxShadow(
      color: Color(0x40FF5722),
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x1A3A1C71),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  static const glowShadowGreen = [
    BoxShadow(
      color: Color(0x4000C853),
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  static const glowShadowTurquoise = [
    BoxShadow(
      color: Color(0x4000E5FF),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const flipCardPattern = [
    BoxShadow(
      color: Color(0x08FF5722),
      blurRadius: 0,
      offset: Offset(0, 0),
    ),
  ];
}

class AndeanTextStyles {
  static const headerLarge = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: AndeanColors.textLight,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const headerMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AndeanColors.textDark,
    letterSpacing: -0.3,
  );

  static const headerSmall = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AndeanColors.textDark,
  );

  static const body = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AndeanColors.textDark,
    height: 1.4,
  );

  static const bodySmall = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AndeanColors.greyCool,
    height: 1.3,
  );

  static const label = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AndeanColors.greyCool,
  );

  static const statNumber = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: AndeanColors.textDark,
  );

  static const statLabel = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AndeanColors.greyCool,
  );

  static const buttonText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AndeanColors.textLight,
    letterSpacing: 0.5,
  );
}

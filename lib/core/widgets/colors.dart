import 'package:flutter/material.dart';

class colorss {
  static const Color primaryColor = Color(0xFF3BBDD8);         // Pembe – Somon (Tatlılar için canlı)
  static const Color primaryColorLight = Color(0xFF319A48);    // Krem / Açık Sarı (Arka planlar veya hafif alanlar)
  static const Color primaryColorDark = Color(0xFF3677CC);     // Turuncu (Koyu varyasyon – Enerjik vurgu)
  static const Color secondaryColor = Color(0xFFA5D6A7);        // Yeşil – İkincil vurgu



  static const Color backgroundColor = Colors.black87;
  static const Color backgroundColorDark = Colors.black;
  static const Color backgroundColorLight = Color(0xFF2C2C2C);

  static const Color textColor = Colors.white;
  static const Color textColorSecondary = Colors.white70;

  static Color getBackgroundGradientStart() => backgroundColor;
  static Color getBackgroundGradientEnd() =>
      backgroundColorDark.withOpacity(0.8);

  static Color getPrimaryGlowColor() => primaryColor.withOpacity(0.2);
  static Color getSecondaryGlowColor() => Colors.transparent;

  static Color getOverlayColor() => backgroundColorDark.withOpacity(0.5);

  static MaterialStateProperty<Color> getPrimaryButtonColor() {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return primaryColorDark;
        }
        return primaryColor;
      },
    );
  }

  static MaterialStateProperty<Color> getCheckboxColor() {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return textColor;
      },
    );
  }

  static BoxDecoration getInputDecoration() {
    return BoxDecoration(
      color: textColor.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: primaryColor.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  static InputDecoration getTextFieldDecoration({
    required String labelText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: textColorSecondary),
      prefixIcon: Icon(prefixIcon, color: primaryColor.withOpacity(0.7)),
      suffixIcon: suffixIcon,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }

  static ButtonStyle getPrimaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      shadowColor: primaryColor.withOpacity(0.5),
    );
  }
}

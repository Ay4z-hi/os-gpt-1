import 'package:flutter/material.dart';

/// Shared design system for Linux, Windows and Android launcher builds.
abstract final class SmthColors {
  static const black = Color(0xFF080808);
  static const surface = Color(0xFF111111);
  static const elevated = Color(0xFF191919);
  static const line = Color(0xFF383838);
  static const grey = Color(0xFF777777);
  static const muted = Color(0xFFAAAAAA);
  static const white = Color(0xFFF2F2F2);
  static const red = Color(0xFFD71921);
}
abstract final class SmthSpace {
  static const x1=4.0, x2=8.0, x3=16.0, x4=24.0, x5=32.0, x6=40.0, x8=64.0;
}
abstract final class SmthRadius {
  static const none=0.0, small=4.0, medium=8.0, large=12.0, round=999.0;
}
abstract final class SmthMotion {
  static const instant=Duration(milliseconds:90);
  static const fast=Duration(milliseconds:160);
  static const normal=Duration(milliseconds:220);
  static const slow=Duration(milliseconds:320);
  static const standard=Curves.easeOutCubic;
}
abstract final class SmthType {
  // Monospace is the offline-safe fallback until bundled Doto/Space Mono assets are added.
  static const display='monospace';
  static const label='monospace';
  static const micro=10.0, small=12.0, body=14.0, title=20.0, displaySize=32.0;
}
abstract final class SmthTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3:true, brightness:Brightness.dark,
    scaffoldBackgroundColor:SmthColors.black, canvasColor:SmthColors.black,
    fontFamily:SmthType.label,
    colorScheme:const ColorScheme.dark(
      primary:SmthColors.red, secondary:SmthColors.white,
      surface:SmthColors.surface, onPrimary:SmthColors.white,
      onSecondary:SmthColors.black, onSurface:SmthColors.white,
      outline:SmthColors.line,
    ),
    dividerColor:SmthColors.line, splashFactory:NoSplash.splashFactory,
    highlightColor:Colors.transparent,
    textTheme:const TextTheme(
      displayLarge:TextStyle(fontFamily:SmthType.display,fontSize:32,height:1.1,color:SmthColors.white,letterSpacing:-1),
      headlineMedium:TextStyle(fontFamily:SmthType.display,fontSize:20,height:1.2,color:SmthColors.white),
      titleMedium:TextStyle(fontFamily:SmthType.label,fontSize:14,height:1.3,color:SmthColors.white),
      bodyMedium:TextStyle(fontFamily:SmthType.label,fontSize:14,height:1.4,color:SmthColors.white),
      bodySmall:TextStyle(fontFamily:SmthType.label,fontSize:12,height:1.35,color:SmthColors.muted),
      labelSmall:TextStyle(fontFamily:SmthType.label,fontSize:10,height:1.2,letterSpacing:.5,color:SmthColors.muted),
    ),
    iconTheme:const IconThemeData(color:SmthColors.white,size:20),
    appBarTheme:const AppBarTheme(backgroundColor:SmthColors.black,foregroundColor:SmthColors.white,elevation:0,centerTitle:false),
    cardTheme:CardThemeData(
      color:SmthColors.surface,elevation:0,
      shape:RoundedRectangleBorder(side:const BorderSide(color:SmthColors.line),borderRadius:BorderRadius.circular(SmthRadius.medium)),
    ),
    inputDecorationTheme:InputDecorationTheme(
      filled:true,fillColor:SmthColors.surface,
      border:OutlineInputBorder(borderRadius:BorderRadius.circular(SmthRadius.small),borderSide:const BorderSide(color:SmthColors.line)),
      enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(SmthRadius.small),borderSide:const BorderSide(color:SmthColors.line)),
      focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(SmthRadius.small),borderSide:const BorderSide(color:SmthColors.red)),
    ),
  );
}

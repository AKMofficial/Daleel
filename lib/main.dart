import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:daleel/screens/splash_screen.dart'; 
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daleel/providers/settings_provider.dart';

const Color colorPrimary = Color(0xFF005BAA);
const Color colorOnPrimary = Color(0xFFFFFFFF);
const Color colorSecondary = Color(0xFFA3C6E6); 
const Color colorOnSecondary = Color(0xFF4D4D4D); 
const Color colorBackground = Color(0xFFFFFFFF); 
const Color colorSurface = Color(0xFFF5F5F5); 
const Color colorOnSurface = Color(0xFF4D4D4D); 
const Color colorOnBackground = Color(0xFF4D4D4D); 
const Color colorError = Color(0xFFD9534F); 
const Color colorSuccess = Color(0xFF3CB371); 
const Color colorWarning = Color(0xFFFFA500); 

void main() {
  
  runApp(
    
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final baseTextTheme = GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme);
    final customTextTheme = baseTextTheme.copyWith(

       displayLarge: baseTextTheme.displayLarge?.copyWith(color: colorOnBackground),
       displayMedium: baseTextTheme.displayMedium?.copyWith(color: colorOnBackground),
       displaySmall: baseTextTheme.displaySmall?.copyWith(color: colorOnBackground),
       headlineLarge: baseTextTheme.headlineLarge?.copyWith(color: colorOnBackground),
       headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: colorOnBackground),
       headlineSmall: baseTextTheme.headlineSmall?.copyWith(color: colorOnBackground),
       titleLarge: baseTextTheme.titleLarge?.copyWith(color: colorOnBackground, fontWeight: FontWeight.bold),
       titleMedium: baseTextTheme.titleMedium?.copyWith(color: colorOnSurface, fontWeight: FontWeight.w500), 
       titleSmall: baseTextTheme.titleSmall?.copyWith(color: colorOnSurface.withOpacity(0.8)), 
       bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: colorOnBackground), 
       bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: colorOnBackground.withOpacity(0.9)), 
       bodySmall: baseTextTheme.bodySmall?.copyWith(color: colorOnBackground.withOpacity(0.7)), 
       labelLarge: baseTextTheme.labelLarge?.copyWith(color: colorOnPrimary, fontWeight: FontWeight.bold), 
       labelMedium: baseTextTheme.labelMedium?.copyWith(color: colorOnSurface), 
       labelSmall: baseTextTheme.labelSmall?.copyWith(color: colorOnSurface.withOpacity(0.7)), 
    ).apply(
       bodyColor: colorOnBackground, 
       displayColor: colorOnBackground,
    );

    final darkTheme = ThemeData(
        brightness: Brightness.dark,
        primaryColor: colorPrimary, 
        fontFamily: GoogleFonts.tajawal().fontFamily,
        scaffoldBackgroundColor: const Color(0xFF121212), 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: colorPrimary, 
          onPrimary: colorOnPrimary, 
          secondary: colorSecondary, 
          onSecondary: colorOnSurface, 
          error: colorError, 
          onError: colorOnPrimary, 
          background: Color(0xFF121212), 
          onBackground: Color(0xFFE0E0E0), 
          surface: Color(0xFF1E1E1E), 
          onSurface: Color(0xFFE0E0E0), 
        ),
         
        textTheme: baseTextTheme.copyWith(
          displayLarge: baseTextTheme.displayLarge?.copyWith(color: const Color(0xFFE0E0E0)),
          displayMedium: baseTextTheme.displayMedium?.copyWith(color: const Color(0xFFE0E0E0)),
          displaySmall: baseTextTheme.displaySmall?.copyWith(color: const Color(0xFFE0E0E0)),
          headlineLarge: baseTextTheme.headlineLarge?.copyWith(color: const Color(0xFFE0E0E0)),
          headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: const Color(0xFFE0E0E0)),
          headlineSmall: baseTextTheme.headlineSmall?.copyWith(color: const Color(0xFFE0E0E0)),
          titleLarge: baseTextTheme.titleLarge?.copyWith(color: const Color(0xFFE0E0E0), fontWeight: FontWeight.bold),
          titleMedium: baseTextTheme.titleMedium?.copyWith(color: const Color(0xFFE0E0E0), fontWeight: FontWeight.w500),
          titleSmall: baseTextTheme.titleSmall?.copyWith(color: const Color(0xB3E0E0E0)), 
          bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: const Color(0xFFE0E0E0)),
          bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: const Color(0xB3E0E0E0)),
          bodySmall: baseTextTheme.bodySmall?.copyWith(color: const Color(0x99E0E0E0)),
          labelLarge: baseTextTheme.labelLarge?.copyWith(color: colorOnPrimary, fontWeight: FontWeight.bold), 
          labelMedium: baseTextTheme.labelMedium?.copyWith(color: const Color(0xFFE0E0E0)),
          labelSmall: baseTextTheme.labelSmall?.copyWith(color: const Color(0xB3E0E0E0)),
        ).apply(
          bodyColor: const Color(0xFFE0E0E0), 
          displayColor: const Color(0xFFE0E0E0),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E1E1E), 
          foregroundColor: const Color(0xFFE0E0E0), 
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFFE0E0E0)),
          actionsIconTheme: const IconThemeData(color: Color(0xFFE0E0E0)),
          titleTextStyle: baseTextTheme.titleLarge?.copyWith(color: const Color(0xFFE0E0E0)),
        ),
         bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: colorPrimary, 
          unselectedItemColor: const Color(0x99E0E0E0), 
          backgroundColor: const Color(0xFF1E1E1E), 
          elevation: 8.0,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: CardTheme(
          elevation: 1.5,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: const Color(0xFF1E1E1E), 
          clipBehavior: Clip.antiAlias,
        ),
        listTileTheme: ListTileThemeData(
          iconColor: colorPrimary, 
          tileColor: const Color(0xFF1E1E1E), 
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          titleTextStyle: baseTextTheme.titleMedium?.copyWith(color: const Color(0xFFE0E0E0)),
          subtitleTextStyle: baseTextTheme.bodyMedium?.copyWith(color: const Color(0xB3E0E0E0)),
        ),
         inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2C2C), 
          hintStyle: baseTextTheme.bodyLarge?.copyWith(color: const Color(0x99E0E0E0)),
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          border: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none ),
          enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none ),
          focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0), borderSide: const BorderSide(color: colorPrimary, width: 1.5)),
          prefixIconColor: colorPrimary,
          suffixIconColor: colorPrimary.withOpacity(0.7),
        ),
         elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary,
            foregroundColor: colorOnPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            textStyle: baseTextTheme.labelLarge,
          ),
        ),
         textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: colorPrimary, 
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: baseTextTheme.labelLarge?.copyWith(color: colorPrimary, fontWeight: FontWeight.bold),
            ),
          ),
         floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: colorPrimary,
            foregroundColor: colorOnPrimary,
            elevation: 2.0,
          ),
        popupMenuTheme: PopupMenuThemeData(
            color: const Color(0xFF2C2C2C), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            elevation: 4.0,
            textStyle: baseTextTheme.bodyMedium?.copyWith(color: const Color(0xFFE0E0E0)),
            enableFeedback: true,
          ),
    );

    return MaterialApp(
      
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(
        
        brightness: Brightness.light,
        primaryColor: colorPrimary,
        fontFamily: GoogleFonts.tajawal().fontFamily,
        scaffoldBackgroundColor: colorBackground, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,

        
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: colorPrimary,
          onPrimary: colorOnPrimary,
          secondary: colorSecondary,
          onSecondary: colorOnSecondary,
          error: colorError,
          onError: colorOnPrimary,
          background: colorBackground, 
          onBackground: colorOnBackground,
          surface: colorSurface, 
          onSurface: colorOnSurface,
        ),

        
        textTheme: customTextTheme,

        
        appBarTheme: AppBarTheme(
          backgroundColor: colorPrimary,
          foregroundColor: colorOnPrimary,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: colorOnPrimary), 
          actionsIconTheme: const IconThemeData(color: colorOnPrimary), 
          titleTextStyle: customTextTheme.titleLarge?.copyWith(color: colorOnPrimary), 
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: colorPrimary,
          unselectedItemColor: colorSecondary,
          backgroundColor: colorSurface, 
          elevation: 8.0,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: CardTheme(
          elevation: 1.5,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: colorSecondary.withOpacity(0.15), 
          clipBehavior: Clip.antiAlias,
        ),
        listTileTheme: ListTileThemeData(
          iconColor: colorPrimary,
          tileColor: colorBackground,
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          titleTextStyle: customTextTheme.titleMedium,
          subtitleTextStyle: customTextTheme.bodyMedium?.copyWith(color: colorOnSurface.withOpacity(0.7)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorSurface, 
          hintStyle: customTextTheme.bodyLarge?.copyWith(color: colorOnSurface.withOpacity(0.5)),
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: colorPrimary, width: 1.5), 
          ),
          prefixIconColor: colorPrimary, 
          suffixIconColor: colorPrimary.withOpacity(0.7), 
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary,
            foregroundColor: colorOnPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)), 
            textStyle: customTextTheme.labelLarge,
          ),
        ),
         textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: colorPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: customTextTheme.labelLarge?.copyWith(color: colorPrimary, fontWeight: FontWeight.bold), 
            ),
          ),
         floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: colorPrimary,
            foregroundColor: colorOnPrimary,
            elevation: 2.0,
          ),
        
        popupMenuTheme: PopupMenuThemeData(
          color: colorSurface, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), 
          elevation: 4.0, 
          textStyle: customTextTheme.bodyMedium?.copyWith(color: colorOnSurface), 
          enableFeedback: true,
        ),
        

      ),
      darkTheme: darkTheme, 
      themeMode: settingsProvider.themeMode, 
      
      localizationsDelegates: const [
        AppLocalizations.delegate, 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), 
        
      ],
      
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false, 
    );
  }
}
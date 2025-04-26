import 'package:flutter/material.dart';
import 'dart:async';
import 'package:daleel/screens/onboarding_screen.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()), 
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor, 
      body: Stack( 
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Icon(Icons.map_outlined, size: 100, color: Theme.of(context).colorScheme.onPrimary), 
                SizedBox(height: 20),
                Text(
                  'دلـــيـــل',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary, 
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'دربـك خــضــر',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 80), 
              ],
            ),
          ),
          
           Positioned(
             bottom: 30, 
             left: 0,
             right: 0,
             child: Text(
                'صنع بإتقان من\nطلبة جامعة الملك سعود', 
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7), 
                  height: 1.5, 
                ),
             ),
           ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.repeat(reverse: true);
    
    _startLoading();
  }

  void _startLoading() async {
    for (int i = 0; i < 100; i++) {
       await Future.delayed(const Duration(milliseconds: 30));
       setState(() {
         _progress = i / 100;
       });
    }
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation.drive(Tween(begin: 0.9, end: 1.1)),
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(24)),
                alignment: Alignment.center,
                child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 48),
              ),
            ),
            const SizedBox(height: 24),
            const Text("MediBot Assistant", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const Text("Your 24/7 Digital Hospital Companion", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 48),
            Container(
              width: 200, height: 4,
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              clipBehavior: Clip.antiAlias,
              child: LinearProgressIndicator(value: _progress, color: const Color(0xFF2563EB), backgroundColor: Colors.transparent),
            ),
            const SizedBox(height: 12),
            Text("${(_progress * 100).toInt()}% Initializing Services", style: TextStyle(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

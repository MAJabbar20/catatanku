import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (auth.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Catatanku",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.teal[900],
              ),
            ),

            const SizedBox(height: 30),

            // --- LOGO PNG DI SPLASH ---
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset("assets/notebook.png"),
              ),
            ),

            const SizedBox(height: 30),
            const Text("Loading..."),

            const SizedBox(height: 10),

            SizedBox(
              width: 200,
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, _) {
                  return LinearProgressIndicator(
                    value: _progressController.value,
                    color: Colors.teal,
                    backgroundColor: Colors.grey[300],
                    minHeight: 4,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

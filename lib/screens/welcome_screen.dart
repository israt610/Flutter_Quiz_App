import 'package:flutter/material.dart';
import '../app/routes.dart';
import '../app/theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: "Israt Jahan Tamanna");

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: Column(
            children: [
              const Spacer(),

              // Top Figma Artwork Illustration Container
              SizedBox(
                width: 260,
                height: 260,
                child: Image.asset(
                  'assets/images/welcome_illustration.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return CustomPaint(painter: _WelcomeIllustrationPainter());
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Title: Quizzical
              const Text(
                "Quizzical",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textDark,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 6),

              // Subtitle: Israt Jahan Tamanna
              Text(
                _nameController.text.isEmpty ? "Israt Jahan Tamanna" : _nameController.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A5568),
                ),
              ),

              const Spacer(),

              // Bottom Primary Button: GET STARTED
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.categories);
                  },
                  child: const Text(
                    "GET STARTED",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fallback CustomPainter for Welcome Illustration
class _WelcomeIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(
      center,
      44,
      Paint()..color = const Color(0xFFFFD8CB),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

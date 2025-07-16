import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadName();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? '';
    _nameController.text = name;
  }

  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    final name = _nameController.text.trim().isEmpty ? 'Demo User' : _nameController.text.trim();
    await _saveName(name);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;
    final gradient = isDarkMode ? darkPrimaryButtonGradient : lightPrimaryButtonGradient;
    final accent = isDarkMode ? darkAccent : lightAccent;
    final accentSecondary = isDarkMode ? darkAccentSecondary : lightAccentSecondary;
    final textColor = isDarkMode ? darkText : lightText;
    final textSecondaryColor = isDarkMode ? darkTextSecondary : lightTextSecondary;
    final cardBg = isDarkMode ? darkCardBg : lightCardBg;
    final cardBorder = isDarkMode ? darkCardBorder : lightCardBorder;
    final logoAsset = isDarkMode ? 'assets/logos/logo-dark.png' : 'assets/logos/logo-light.png';

    // Set status bar style dynamically
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Let header gradient show behind status bar
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
    ));

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDarkMode ? darkBg : lightBg,
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ Grid fills the entire background
            Positioned.fill(
              child: CustomPaint(
                painter: _GridPainter(
                  color: isDarkMode
                      ? darkTextSecondary.withOpacity(0.05)
                      : lightTextSecondary.withOpacity(0.05),
                ),
              ),
            ),

            // ✅ Header background overlays grid
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? darkScrolledHeaderBg : lightScrolledHeaderBg,
              ),
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              height: kToolbarHeight + 24, // Responsive header height
              width: double.infinity,
            ),

            // ✅ Real header (logo + title + toggle)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode ? darkScrolledHeaderBg : lightScrolledHeaderBg,
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? darkHeaderShadow : lightHeaderShadow,
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(logoAsset, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ClassmateAI',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        isDarkMode ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
                        color: textColor,
                      ),
                      onPressed: _toggleTheme,
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Login form centered below
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Gradient top border
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: isDarkMode ? darkMainGradient180Deg : lightMainGradient180Deg,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Logo
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(logoAsset, fit: BoxFit.cover),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Title
                                ShaderMask(
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      colors: [accent, accentSecondary],
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    'Welcome to the Demo',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Subtitle
                                Text(
                                  'Get started with one click',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textSecondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Name field
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter your name (optional)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Demo message
                                Text(
                                  '🚀 No password needed. Click below to continue.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textSecondaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),

                                // Login button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: gradient,
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: [
                                          BoxShadow(
                                            color: accent.withOpacity(0.4),
                                            blurRadius: 20,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        alignment: Alignment.center,
                                        child: _isLoading
                                            ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                            : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(FontAwesomeIcons.rocket, color: Colors.white),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Enter Demo',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the grid background
class _GridPainter extends CustomPainter {
  final Color color;

  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
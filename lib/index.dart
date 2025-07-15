import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'theme/app_theme.dart';
import 'widgets/grid_background.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _isMobileMenuOpen = false;
  bool _isDarkMode = false; // Add theme state variable
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  void _scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  // Add theme toggle method
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use local theme state instead of Theme.of(context)
    final isDark = _isDarkMode;
    final headerTextColor = (!_isScrolled && !isDark) ? Colors.white : (isDark ? Colors.white : Colors.black);
    final headerBgColor = _isScrolled
        ? (isDark ? const Color(0xFF0F0F0F).withOpacity(0.9) : const Color(0xFFFFFFFF).withOpacity(0.8))
        : Colors.transparent;

    return Theme(
      // Apply theme based on local state
      data: isDark ? darkTheme : lightTheme,
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70), // Fixed height similar to CSS
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // 0.75rem ≈ 12px, 1.5rem ≈ 24px
            decoration: BoxDecoration(
              color: headerBgColor,
              boxShadow: _isScrolled ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: AppBar(
              toolbarHeight: 70 - 24, // Subtract vertical padding (12px top + 12px bottom)
              backgroundColor: Colors.transparent,
              elevation: 0, // Remove default shadow
              scrolledUnderElevation: 0,
              title: MediaQuery.of(context).size.width > 768
                  ? null
                  : _buildLogo(isDark),
              flexibleSpace: MediaQuery.of(context).size.width > 768
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Similar to CSS justify-content: space-between
                          children: [
                            _buildLogo(isDark),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildNavButton("Home", () => _scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.easeInOut)),
                                _buildNavButton("Features", () => _scrollTo(_featuresKey)),
                                _buildNavButton("Contact", () => _scrollTo(_contactKey)),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(isDark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon),
                                  color: headerTextColor,
                                  onPressed: _toggleTheme,
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  height: 40,
                                  child: _GradientButton(
                                    gradient: isDark ? darkPrimaryButtonGradient : lightPrimaryButtonGradient,
                                    onPressed: () => Navigator.pushNamed(context, '/login'),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(FontAwesomeIcons.signInAlt, size: 14, color: lightBg),
                                        SizedBox(width: 6),
                                        Text('Login/Signup', style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
              actions: [
                if (MediaQuery.of(context).size.width <= 768)
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.bars),
                    color: headerTextColor,
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  ),
              ],
            ),
          ),
        ),
        endDrawer: _buildMobileDrawer(isDark),
        body: Stack(
          children: [
            // Fixed Grid background (equivalent to .grid-bg in HTML)
            Positioned.fill(
              child: Opacity(
                opacity: 0.4,
                child: _createGridImage(isDark),
              ),
            ),

            // Scrollable content
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Hero section with gradient background (equivalent to .hero-bg in HTML)
                  _buildHeroBgSection(isDark),
                  _buildFeaturesSection(key: _featuresKey, isDark: isDark),
                  _buildStudentSuccessSection(isDark: isDark),
                  _buildContactSection(key: _contactKey, isDark: isDark),
                  _buildFooter(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createGridImage(bool isDark) {
    final color = isDark ? darkCardBorder : lightCardBorder;
    return GridBackground(
      lineColor: color,
      gridSize: 40.0, // Match HTML background-size: 40px 40px
    );
  }

  // New method to build hero background section (equivalent to .hero-bg in HTML)
  Widget _buildHeroBgSection(bool isDark) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: Stack(
        children: [
          // Hero gradient background (equivalent to .hero-gradient in HTML)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: isDark ? darkHeroGradient: lightHeroGradient,
              ),
            ),
          ),

          // Overlay gradient to fade into background (equivalent to the second gradient in HTML)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    isDark ? darkBg.withAlpha(0) : lightBg.withAlpha(0),
                    isDark ? darkBg.withAlpha(0) : lightBg.withAlpha(0),
                    isDark ? darkBg : lightBg, // 98%
                  ],
                  stops: const [0.0, 0.4, 0.98],
                ),
              ),
            ),
          ),

          // Hero content
          _buildHeroSection(),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    final showWhiteLogo = isDark || !_isScrolled;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          showWhiteLogo ? 'assets/logos/logo-dark.png' : 'assets/logos/logo-light.png',
          height: 50,
          filterQuality: FilterQuality.high,
        ),
        const SizedBox(width: 8),
        Text(
          "ClassmateAI",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: showWhiteLogo ? Colors.white : (isDark ? Colors.white : Colors.black),
          ),
        )
      ],
    );
  }

  Widget _buildNavButton(String text, VoidCallback onPressed) {
    final isDark = _isDarkMode;
    final color = (isDark || !_isScrolled) ? darkText : lightText;
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 15,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(bool isDark) {
    return Drawer(
      backgroundColor: isDark ? darkBg : lightBg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: isDark ? darkHeroGradient : lightHeroGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogo(isDark),
                const SizedBox(height: 16),
                Text(
                  "Menu",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Home', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              _scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
            },
          ),
          ListTile(
            title: Text('Features', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              _scrollTo(_featuresKey);
            },
          ),
          ListTile(
            title: Text('Contact', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pop(context);
              _scrollTo(_contactKey);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(isDark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon),
            title: Text(isDark ? 'Light Mode' : 'Dark Mode'),
            onTap: () {
              Navigator.pop(context);
              _toggleTheme(); // Use the proper toggle method
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _GradientButton(
              gradient: isDark ? darkPrimaryButtonGradient : lightPrimaryButtonGradient,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.signInAlt,color: lightBg),
                  SizedBox(width: 8),
                  Text('Login/Signup'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.9),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36.4),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Personal AI Learning Assistant.",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: MediaQuery.of(context).size.width > 768 ? 80 : 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 36.4),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Text(
                    "Classmate AI helps you learn smarter, not harder. Get personalized study plans, instant answers to your questions, and intelligent insights to boost your academic performance.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: MediaQuery.of(context).size.width > 768 ? 24 : 16,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 156,
                height: 45,
                child: _GradientButton(
                  gradient: _isDarkMode
                      ? darkPrimaryButtonGradient
                      : lightPrimaryButtonGradient,
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.rocket, size: 18, color: lightBg,),
                      SizedBox(width: 12),
                      Text("Get Started"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection({required GlobalKey key, required bool isDark}) {
    final features = [
      {'icon': FontAwesomeIcons.robot, 'title': 'Chatbot AI', 'desc': 'Get instant answers to your study questions with our intelligent AI assistant available 24/7.'},
      {'icon': FontAwesomeIcons.chartLine, 'title': 'Personal Dashboard', 'desc': 'Visualize your academic progress with customizable charts and performance metrics.'},
      {'icon': FontAwesomeIcons.book, 'title': 'Smart Notes', 'desc': 'Organize, search, and highlight your notes with AI-powered suggestions and summaries.'},
      {'icon': FontAwesomeIcons.tasks, 'title': 'Task Manager', 'desc': 'Stay on top of assignments and deadlines with intelligent prioritization and reminders.'},
      {'icon': FontAwesomeIcons.percent, 'title': 'Attendance Calculator', 'desc': 'Track your class attendance and get alerts when you\'re at risk of falling below requirements.'},
      {'icon': FontAwesomeIcons.cogs, 'title': 'Settings & Customization', 'desc': 'Personalize your dashboard, toggle dark mode, and adjust features to match your study style.'},
    ];

    return Container(
      key: key,
      color: isDark ? darkBg : lightBg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 992
                  ? 3
                  : (constraints.maxWidth > 768 ? 2 : 1);

              // Use fixed card height instead of aspect ratio
              return Wrap(
                spacing: 32,
                runSpacing: 32,
                children: features.map((feature) {
                  final rawCardWidth = (constraints.maxWidth - (crossAxisCount - 1) * 32) / crossAxisCount;
                  final cardWidth = rawCardWidth > 450 ? 350.0 : rawCardWidth;
                  return SizedBox(
                    width: cardWidth,
                    child: _FeatureCard(
                      icon: feature['icon'] as IconData,
                      title: feature['title'] as String,
                      description: feature['desc'] as String,
                      isDark: isDark,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStudentSuccessSection({required bool isDark}) {
    return Container(
      color: Theme.of(context).cardTheme.color,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 36.4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 992;
                return Flex(
                  direction: isDesktop ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: isDesktop ? 1 : 0,
                      child: _buildSuccessText(isDark),
                    ),
                    SizedBox(width: isDesktop ? 32 : 0, height: isDesktop ? 0 : 32),
                    Expanded(
                      flex: isDesktop ? 1 : 0,
                      child: _buildSuccessStats(isDark),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessText(bool isDark) {
    final benefits = [
      {'icon': FontAwesomeIcons.chartLine, 'title': 'Boost Academic Performance', 'desc': 'Students using Classmate report an average 15% improvement in grades and assignment completion rates.'},
      {'icon': FontAwesomeIcons.heart, 'title': 'Reduce Stress and Anxiety', 'desc': 'Never miss a deadline or forget an assignment again. Our smart reminder system keeps you on track.'},
      {'icon': FontAwesomeIcons.clock, 'title': 'Save Valuable Time', 'desc': 'Our AI assistant helps you study smarter, not harder, by providing instant answers and summarizing complex materials.'},
      {'icon': FontAwesomeIcons.layerGroup, 'title': 'Centralize Your Academic Life', 'desc': 'Keep all your notes, assignments, schedules, and resources in one secure, accessible place.'}
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Why Students Choose Classmate",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "We understand the unique challenges students face. Here's how Classmate helps you overcome them:",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 32),
        ...benefits.map((b) => _BenefitItem(
          icon: b['icon'] as IconData,
          title: b['title'] as String,
          desc: b['desc'] as String,
          isDark: isDark,
        )),
      ],
    );
  }

  Widget _buildSuccessStats(bool isDark) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            "https://readdy.ai/api/search-image?query=A%20group%20of%20diverse%20college%20students%20studying%20together%20in%20a%20modern%20library%20or%20campus%20setting.%20They%20are%20using%20laptops%20and%20tablets%2C%20looking%20engaged%20and%20productive.%20Some%20students%20are%20collaborating%20while%20others%20are%20focused%20on%20individual%20work.%20The%20scene%20shows%20a%20mix%20of%20male%20and%20female%20students%20from%20different%20backgrounds%2C%20all%20appearing%20motivated%20and%20successful%20in%20their%20academic%20pursuits.%20The%20lighting%20is%20bright%20and%20natural.&width=800&height=600&seq=students&orientation=landscape",
            fit: BoxFit.cover,
            height: 300,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 300,
              color: Colors.grey.shade300,
              child: const Center(child: Text("Image not found")),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: isDark ? darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? darkCardBorder : lightCardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Student Success Rate",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Based on survey of 2,500+ students",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "94%",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _StatBar(label: "Improved Organization", value: 96, isDark: isDark),
              _StatBar(label: "Better Time Management", value: 92, isDark: isDark),
              _StatBar(label: "Reduced Academic Stress", value: 89, isDark: isDark),
              _StatBar(label: "Grade Improvement", value: 87, isDark: isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection({required GlobalKey key, required bool isDark}) {

    return Container(
      key: key,
      color: Theme.of(context).cardTheme.color,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 36.4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                Text(
                  "Contact Us",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color:
                    isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "We'd love to hear from you! Reach out to us using any of the methods below:",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 48),
                _ContactInfoTile(
                  icon: FontAwesomeIcons.envelope,
                  title: 'Email',
                  details: [
                    'sriramchodabattula777@gmail.com',
                    'evvganesh1@gmail.com',
                    'sivaganeshv1729@gmail.com',
                    'nagaveeranna1234@gmail.com',
                  ],
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
                _ContactInfoTile(
                  icon: FontAwesomeIcons.linkedin,
                  title: 'LinkedIn',
                  details: [
                    '@sriram-chodabattula',
                    '@siva-ganesh-vemula',
                    '@venkata-ganesh',
                    '@naga-veeranna',
                  ],
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
                _ContactInfoTile(
                  icon: FontAwesomeIcons.phone,
                  title: 'Phone',
                  details: ['+91 8328465631'],
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(bool isDark) {
    return Container(
      color: isDark ? darkCardBg : lightCardBg,
      padding: const EdgeInsets.all(48),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36.4),
        child: Column(
          children: [
            _buildLogo(isDark),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 12,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "About Us",
                    style: GoogleFonts.plusJakartaSans(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _scrollTo(_featuresKey),
                  child: Text(
                    "Features",
                    style: GoogleFonts.plusJakartaSans(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _scrollTo(_contactKey),
                  child: Text(
                    "Contact Us",
                    style: GoogleFonts.plusJakartaSans(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              children: [
                _SocialIcon(FontAwesomeIcons.twitter),
                _SocialIcon(FontAwesomeIcons.facebook),
                _SocialIcon(FontAwesomeIcons.instagram),
                _SocialIcon(FontAwesomeIcons.linkedin),
                _SocialIcon(FontAwesomeIcons.youtube),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "© 2025 Classmate AI. All rights reserved.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final LinearGradient gradient;

  const _GradientButton({
    required this.onPressed,
    required this.child,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 4, // Lower elevation to match HTML
        minimumSize: const Size(0, 36), // Reduced height for header button
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Reduced vertical padding
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.white,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkCardBg : lightCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? darkCardBorder : lightCardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gradient bar at top
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: isDark ? darkHeroGradient : lightHeroGradient,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isDark ? darkHeroGradient : lightHeroGradient,
                    ),
                    child: Center(
                      child: FaIcon(icon, size: 30, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? darkText : lightText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      color: (isDark ? darkText : lightText).withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool isDark;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: isDark ? darkHeroGradient : lightHeroGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: FaIcon(icon, size: 18, color: Colors.white)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value;
  final bool isDark;

  const _StatBar({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                '$value%',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity, // Ensure full width
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).dividerColor,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value / 100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: isDark
                          ? [
                        const Color(0xFF3a54cc),
                        const Color(0xFF6b2bb3),
                        const Color(0xFFcc2f7d),
                        const Color(0xFFcc1f5d),
                      ]
                          : [
                        const Color(0xFF4d6bff),
                        const Color(0xFF863ae0),
                        const Color(0xFFff3c9e),
                        const Color(0xFFff2673),
                      ],
                      stops: const [0.0, 0.25, 0.70, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;

  const _SocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).cardTheme.color,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Center(
        child: FaIcon(
          icon,
          size: 20,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
        ),
      ),
    );
  }
}

class _ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> details;
  final bool isDark; // Add this

  const _ContactInfoTile({
    required this.icon,
    required this.title,
    required this.details,
    required this.isDark, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FaIcon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              ...details.map((detail) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  detail,
                  style: GoogleFonts.plusJakartaSans(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).primaryColor,
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

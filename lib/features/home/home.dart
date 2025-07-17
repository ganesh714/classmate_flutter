import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../dashboard_page.dart';
import '../chatbot_page.dart';
import '../notes_page.dart';
import '../task_manager_page.dart';
import '../attendance_calc_page.dart';
import '../settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _isDarkMode = false;
  bool _isPanelExpanded = false;
  String _currentPage = 'dashboard';
  String _panelExpandMode = 'static'; // 'static' or 'hover'

  // User info
  String _userName = 'Demo User';
  String _userEmail = 'demo@example.com';
  String _userAvatar = 'https://randomuser.me/api/portraits/men/32.jpg';

  // Animation controllers
  late AnimationController _panelAnimationController;
  late Animation<double> _panelAnimation;

  // Navigation items for mobile (limited to fit in bottom nav)
  final List<Map<String, dynamic>> _mobileNavItems = [
    {
      'id': 'dashboard',
      'icon': FontAwesomeIcons.chartColumn,
      'title': 'Dashboard'
    },
    {'id': 'chatbot', 'icon': FontAwesomeIcons.robot, 'title': 'AI Chatbot'},
    {'id': 'notes', 'icon': FontAwesomeIcons.stickyNote, 'title': 'Notes'},
    {
      'id': 'taskManager',
      'icon': FontAwesomeIcons.tasks,
      'title': 'Task Manager'
    },
    {
      'id': 'attendance',
      'icon': FontAwesomeIcons.calendarDays,
      'title': 'Attendance'
    },
    {'id': 'settings', 'icon': FontAwesomeIcons.cog, 'title': 'Settings'},
    {
      'id': 'darkToggle',
      'icon': null,
      'title': 'Dark Mode',
      'isToggle': true
    }, // icon will be set dynamically
  ];

  // Navigation items for desktop
  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': 'dashboard',
      'icon': FontAwesomeIcons.chartColumn,
      'title': 'Dashboard'
    },
    {'id': 'chatbot', 'icon': FontAwesomeIcons.robot, 'title': 'AI Chatbot'},
    {'id': 'notes', 'icon': FontAwesomeIcons.stickyNote, 'title': 'Notes'},
    {
      'id': 'taskManager',
      'icon': FontAwesomeIcons.tasks,
      'title': 'Task Manager'
    },
    {
      'id': 'attendance',
      'icon': FontAwesomeIcons.calendarDays,
      'title': 'Attendance'
    },
  ];

  final List<Map<String, dynamic>> _systemItems = [
    {'id': 'settings', 'icon': FontAwesomeIcons.cog, 'title': 'Settings'},
  ];

  @override
  void initState() {
    super.initState();
    _panelAnimationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _panelAnimation = CurvedAnimation(
      parent: _panelAnimationController,
      curve: Curves.easeInOut,
    );

    // Load saved preferences
    _loadPreferences();
  }

  @override
  void dispose() {
    _panelAnimationController.dispose();
    super.dispose();
  }

  void _loadPreferences() {
    // In a real app, load from SharedPreferences
    setState(() {
      _isDarkMode = false; // Default to light mode
      _isPanelExpanded = false; // Default to narrow panel
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _togglePanel() {
    setState(() {
      _isPanelExpanded = !_isPanelExpanded;
      if (_isPanelExpanded) {
        _panelAnimationController.forward();
      } else {
        _panelAnimationController.reverse();
      }
    });
  }

  void _setActivePage(String pageId) {
    setState(() {
      _currentPage = pageId;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _isDarkMode ? darkCardBg : lightCardBg,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Confirm Logout',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _isDarkMode ? darkText : lightText,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.inter(
              color: _isDarkMode ? darkTextSecondary : lightTextSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: _isDarkMode ? darkCardBg : lightCardBg,
                side: BorderSide(
                    color: _isDarkMode ? darkCardBorder : lightCardBorder),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: _isDarkMode ? darkText : lightText,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogout();
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() {
    // Clear session data and navigate to login
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    final panelWidth = _isPanelExpanded ? 240.0 : 80.0;
    final expandBtnWidth = 30.0;

    return Theme(
      data: _isDarkMode ? darkTheme : lightTheme,
      child: Scaffold(
        backgroundColor: _isDarkMode ? darkBg : lightBg,
        body: Stack(
          children: [
            // Grid background
            _buildGridBackground(),

            // Desktop layout
            if (isDesktop)
              Row(
                children: [
                  // Side panel
                  _buildSidePanel(),

                  // Main content
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: !isDesktop
                            ? 60
                            : 0, // Add bottom margin for mobile nav
                      ),
                      child: _buildMainContent(),
                    ),
                  ),
                ],
              )
            else
              // Mobile layout (original Stack structure)
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: !isDesktop ? 60 : 0,
                        ),
                        child: _buildMainContent(),
                      ),
                    ),
                    _buildBottomNavigation(),
                  ],
                ),
              ),

            // Expand button (only visible when panel is collapsed and on desktop)
            if (isDesktop && !_isPanelExpanded)
              Positioned(
                left:
                    panelWidth, // Position button directly to the right of the panel
                top: 40, // Adjust to align with logo center if needed
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: _togglePanel,
                    child: Container(
                      width: expandBtnWidth,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _isDarkMode ? darkCardBorder : lightCardBorder,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(2, 0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.chevronRight,
                          size: 16,
                          color: _isDarkMode ? darkText : lightText,
                        ),
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

  Widget _buildGridBackground() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.4,
        child: CustomPaint(
          painter: GridPainter(
            color: _isDarkMode ? darkCardBorder : lightCardBorder,
            gridSize: 40.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSidePanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      width: _isPanelExpanded ? 240 : 80,
      height: double.infinity,
      decoration: BoxDecoration(
        color: _isDarkMode ? darkCardBg : lightCardBg,
        border: Border(
          right:
              BorderSide(color: _isDarkMode ? darkCardBorder : lightCardBorder),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _isPanelExpanded ? _buildExpandedPanel() : _buildNarrowPanel(),
    );
  }

  Widget _buildNarrowPanel() {
    return Column(
      children: [
        // Logo section
        Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Image.asset(
              _isDarkMode
                  ? 'assets/logos/logo-dark.png'
                  : 'assets/logos/logo-light.png',
              height: 50,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _isDarkMode ? darkAccent : lightAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  FontAwesomeIcons.graduationCap,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),

        // Navigation items group - wrapped in a container to prevent overflow
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Menu items
                ..._menuItems.map((item) => _buildNarrowNavItem(item)),

                // System items
                ..._systemItems.map((item) => _buildNarrowNavItem(item)),

                // Dark mode toggle
                _buildNarrowNavItem({
                  'id': 'darkToggle',
                  'icon': _isDarkMode
                      ? FontAwesomeIcons.sun
                      : FontAwesomeIcons.moon,
                  'title': 'Dark Mode',
                  'isToggle': true,
                }),
              ],
            ),
          ),
        ),

        // User profile
        Container(
          margin: const EdgeInsets.all(16),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(_userAvatar),
            backgroundColor: _isDarkMode ? darkAccent : lightAccent,
          ),
        ),

        // Logout button
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildNarrowNavItem({
            'id': 'logout',
            'icon': FontAwesomeIcons.signOutAlt,
            'title': 'Logout',
            'isLogout': true,
          }),
        ),
      ],
    );
  }

  Widget _buildExpandedPanel() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      _isDarkMode
                          ? 'assets/logos/logo-dark.png'
                          : 'assets/logos/logo-light.png',
                      height: 50,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _isDarkMode ? darkAccent : lightAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FontAwesomeIcons.graduationCap,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            _isDarkMode
                                ? darkAccentSecondary
                                : lightAccentSecondary,
                            _isDarkMode ? darkAccent : lightAccent,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          'Classmate',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _togglePanel,
                icon: Icon(
                  FontAwesomeIcons.chevronLeft,
                  size: 16,
                  color: _isDarkMode ? darkTextSecondary : lightTextSecondary,
                ),
              ),
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menu section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MENU',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _isDarkMode
                              ? darkTextSecondary
                              : lightTextSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._menuItems.map((item) => _buildExpandedNavItem(item)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // System section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SYSTEM',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _isDarkMode
                              ? darkTextSecondary
                              : lightTextSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._systemItems
                          .map((item) => _buildExpandedNavItem(item)),
                      _buildExpandedNavItem({
                        'id': 'darkToggle',
                        'icon': _isDarkMode
                            ? FontAwesomeIcons.sun
                            : FontAwesomeIcons.moon,
                        'title': 'Dark mode',
                        'isToggle': true,
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // User profile section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: _isDarkMode ? darkCardBorder : lightCardBorder),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(_userAvatar),
                    backgroundColor: _isDarkMode ? darkAccent : lightAccent,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _isDarkMode ? darkText : lightText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _userEmail,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: _isDarkMode
                                ? darkTextSecondary
                                : lightTextSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildExpandedNavItem({
                'id': 'logout',
                'icon': FontAwesomeIcons.signOutAlt,
                'title': 'Log out',
                'isLogout': true,
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowNavItem(Map<String, dynamic> item) {
    final isActive = _currentPage == item['id'];
    final isToggle = item['isToggle'] == true;
    final isLogout = item['isLogout'] == true;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GestureDetector(
        onTap: () {
          if (isToggle) {
            _toggleTheme();
          } else if (isLogout) {
            _showLogoutDialog();
          } else {
            _setActivePage(item['id']);
          }
        },
        child: Tooltip(
          message: item['title'],
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive
                  ? (_isDarkMode
                      ? darkCardBorder.withOpacity(0.2)
                      : lightAccent.withOpacity(0.15))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: FaIcon(
                item['icon'],
                size: 20,
                color: isActive
                    ? (_isDarkMode ? darkAccent : lightAccent)
                    : (_isDarkMode ? darkTextSecondary : lightTextSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedNavItem(Map<String, dynamic> item) {
    final isActive = _currentPage == item['id'];
    final isToggle = item['isToggle'] == true;
    final isLogout = item['isLogout'] == true;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GestureDetector(
        onTap: () {
          if (isToggle) {
            _toggleTheme();
          } else if (isLogout) {
            _showLogoutDialog();
          } else {
            _setActivePage(item['id']);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? (_isDarkMode
                    ? darkCardBorder.withOpacity(0.2)
                    : lightCardBorder.withOpacity(0.2))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isActive
                ? Border(
                    left: BorderSide(
                      color: _isDarkMode ? darkAccent : lightAccent,
                      width: 3,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                child: Center(
                  child: FaIcon(
                    item['icon'],
                    size: 16,
                    color: isActive
                        ? (_isDarkMode ? darkAccent : lightAccent)
                        : (_isDarkMode
                            ? darkTextSecondary
                            : lightTextSecondary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item['title'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                    color: isActive
                        ? (_isDarkMode ? darkAccent : lightAccent)
                        : (_isDarkMode ? darkText : lightText),
                  ),
                ),
              ),
              if (isToggle) _buildToggleSwitch(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Container(
      width: 40,
      height: 20,
      decoration: BoxDecoration(
        color: _isDarkMode ? darkAccent : lightCardBorder,
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: _isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: _isDarkMode ? darkText : lightCardBg,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    // Only show the main nav items and dark toggle, in the same order as HTML
    final List<Map<String, dynamic>> navItems = [
      {
        'id': 'dashboard',
        'icon': FontAwesomeIcons.chartColumn,
        'title': 'Dashboard'
      },
      {'id': 'chatbot', 'icon': FontAwesomeIcons.robot, 'title': 'AI Chatbot'},
      {'id': 'notes', 'icon': FontAwesomeIcons.stickyNote, 'title': 'Notes'},
      {
        'id': 'taskManager',
        'icon': FontAwesomeIcons.tasks,
        'title': 'Task Manager'
      },
      {
        'id': 'attendance',
        'icon': FontAwesomeIcons.calendarDays,
        'title': 'Attendance'
      },
      {'id': 'settings', 'icon': FontAwesomeIcons.cog, 'title': 'Settings'},
      {
        'id': 'darkToggle',
        'icon': _isDarkMode ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
        'title': 'Dark Mode',
        'isToggle': true,
      },
    ];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: _isDarkMode ? darkCardBg : lightCardBg,
          border: Border(
            top: BorderSide(
                color: _isDarkMode ? darkCardBorder : lightCardBorder),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 32,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navItems.map((item) => _buildBottomNavItem(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(Map<String, dynamic> item) {
    final isActive = _currentPage == item['id'];
    final isToggle = item['isToggle'] == true;

    return GestureDetector(
      onTap: () {
        if (isToggle) {
          _toggleTheme();
        } else {
          _setActivePage(item['id']);
        }
      },
      child: Tooltip(
        message: item['title'],
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive
                ? (_isDarkMode
                    ? darkCardBorder.withOpacity(0.2)
                    : lightAccent.withOpacity(0.15))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: FaIcon(
              item['icon'],
              size: 20,
              color: isActive
                  ? (_isDarkMode ? darkAccent : lightAccent)
                  : (_isDarkMode ? darkTextSecondary : lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    Widget pageWidget;
    switch (_currentPage) {
      case 'dashboard':
        pageWidget = const DashboardPage();
        break;
      case 'chatbot':
        pageWidget = const ChatbotPage();
        break;
      case 'notes':
        pageWidget = const NotesPage();
        break;
      case 'taskManager':
        pageWidget = const TaskManagerPage();
        break;
      case 'attendance':
        pageWidget = const AttendanceCalcPage();
        break;
      case 'settings':
        pageWidget = const SettingsPage();
        break;
      default:
        pageWidget = const DashboardPage();
    }
    return pageWidget;
  }
}

// Custom painter for grid background
class GridPainter extends CustomPainter {
  final Color color;
  final double gridSize;

  GridPainter({required this.color, required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

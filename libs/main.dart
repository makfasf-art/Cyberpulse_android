/// ============================================================================
/// CYBERPULSE - ALL-IN-ONE SINGLE FILE FLUTTER ANDROID APPLICATION
/// File: lib/main.dart
/// 
/// Seluruh arsitektur, tema, widget, dan halaman disatukan ke dalam 1 file ini.
/// Cukup salin seluruh isi file ini ke lib/main.dart pada proyek Flutter Anda!
///
/// Dependencies yang dibutuhkan di pubspec.yaml:
/// dependencies:
///   flutter:
///     sdk: flutter
///   cupertino_icons: ^1.0.6
///   google_fonts: ^6.1.0
/// ============================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================================
// 1. TEMA & KONSTANTA WARNA (HITAM, BIRU NEON, MERAH NEON)
// ============================================================================

class CyberpunkTheme {
  static const Color bgDark = Color(0xFF07090E); // Hitam Angkasa
  static const Color cardDark = Color(0xFF0F1522); // Hitam Panel
  static const Color neonBlue = Color(0xFF00F0FF); // Biru Neon Utama
  static const Color neonRed = Color(0xFFFF0055); // Merah Neon Utama
  static const Color neonPurple = Color(0xFF9D00FF); // Ungu Aksen
  static const Color textMuted = Color(0xFF94A3B8); // Abu-abu Soft

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: neonBlue,
      colorScheme: const ColorScheme.dark(
        primary: neonBlue,
        secondary: neonRed,
        surface: cardDark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.orbitron(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: neonBlue,
        ),
        bodyLarge: GoogleFonts.rajdhani(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.rajdhani(
          fontSize: 14,
          color: textMuted,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgDark.withOpacity(0.92),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: neonBlue,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: neonBlue),
      ),
    );
  }

  static BoxDecoration neonCard({
    Color borderColor = neonBlue,
    Color bgColor = cardDark,
    double radius = 14.0,
  }) {
    return BoxDecoration(
      color: bgColor.withOpacity(0.85),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor.withOpacity(0.55), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: borderColor.withOpacity(0.18),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ],
    );
  }
}

// ============================================================================
// 2. ENTRY POINT (MAIN FUNCTION)
// ============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CyberPulseAllInOneApp());
}

class CyberPulseAllInOneApp extends StatelessWidget {
  const CyberPulseAllInOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberPulse Android',
      debugShowCheckedModeBanner: false,
      theme: CyberpunkTheme.themeData,
      home: const SplashScreen(),
    );
  }
}

// ============================================================================
// 3. BACKGROUND LUAR ANGKASA (STARFIELD CANVAS ANIMATION)
// ============================================================================

class SpaceStarfieldBackground extends StatefulWidget {
  final Widget child;
  const SpaceStarfieldBackground({super.key, required this.child});

  @override
  State<SpaceStarfieldBackground> createState() =>
      _SpaceStarfieldBackgroundState();
}

class _SpaceStarfieldBackgroundState extends State<SpaceStarfieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<StarPoint> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 90; i++) {
      _stars.add(StarPoint(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2.2 + 0.6,
        speed: _random.nextDouble() * 0.002 + 0.0006,
        color: i % 4 == 0
            ? CyberpunkTheme.neonBlue
            : (i % 6 == 0 ? CyberpunkTheme.neonRed : Colors.white),
      ));
    }

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            setState(() {
              for (var star in _stars) {
                star.y += star.speed;
                if (star.y > 1.0) {
                  star.y = 0.0;
                  star.x = _random.nextDouble();
                }
              }
            });
          })
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.3),
              radius: 1.2,
              colors: [Color(0xFF0D1527), Color(0xFF07090E), Colors.black],
            ),
          ),
        ),
        CustomPaint(
          size: Size.infinite,
          painter: StarfieldPainter(stars: _stars),
        ),
        widget.child,
      ],
    );
  }
}

class StarPoint {
  double x, y;
  final double size, speed;
  final Color color;
  StarPoint({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}

class StarfieldPainter extends CustomPainter {
  final List<StarPoint> stars;
  StarfieldPainter({required this.stars});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var star in stars) {
      paint.color = star.color;
      canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height), star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ============================================================================
// 4. SPLASH SCREEN (SASUKE UCHIHA, PROGRESS BAR NEON, TIMEOUT 3 DETIK)
// ============================================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _progressValue = 0.0;
  Timer? _timer;
  late AnimationController _pulseController;

  final String _sasukeImageUrl =
      'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600&auto=format&fit=crop&q=80';

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Hitung mundur 3 detik (30ms x 100 step = 3000ms)
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        _progressValue += 0.01;
        if (_progressValue >= 1.0) {
          _progressValue = 1.0;
          _timer?.cancel();
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const MainShellScreen(),
              transitionsBuilder: (_, anim, __, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SpaceStarfieldBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SYSTEM INITIALIZATION // 3.0s',
                  style: GoogleFonts.orbitron(
                    fontSize: 12,
                    letterSpacing: 3.0,
                    color: CyberpunkTheme.neonRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),

                // Gambar Karakter Sasuke Uchiha di Tengah dengan Border Glow Biru Neon
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 175,
                      height: 175,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: CyberpunkTheme.neonBlue, width: 3.0),
                        boxShadow: [
                          BoxShadow(
                            color: CyberpunkTheme.neonBlue.withOpacity(
                                0.35 + (_pulseController.value * 0.4)),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                          BoxShadow(
                            color: CyberpunkTheme.neonRed.withOpacity(0.3),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          _sasukeImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 80,
                            color: CyberpunkTheme.neonBlue,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                Text(
                  'SASUKE UCHIHA',
                  style: GoogleFonts.orbitron(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'CHIDORI MATRIX • CYBERPULSE',
                  style: GoogleFonts.rajdhani(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: CyberpunkTheme.neonBlue,
                  ),
                ),
                const SizedBox(height: 36),

                // Loading Progress Bar Berwarna Biru Neon
                SizedBox(
                  width: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      minHeight: 8,
                      backgroundColor: CyberpunkTheme.cardDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          CyberpunkTheme.neonBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'Loading Core: ${(_progressValue * 100).toInt()}%',
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    color: CyberpunkTheme.neonBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 5. MAIN SHELL (NAVIGASI 3 TAB & SIDEBAR DRAWER)
// ============================================================================

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    DashboardScreenTab(),
    SettingsScreenTab(),
    AdminPanelScreenTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'CYBERPULSE // DASHBOARD'
              : (_currentIndex == 1 ? 'CONFIG // SETTINGS' : 'ROOT // ADMIN'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: CyberpunkTheme.neonBlue),
            tooltip: 'Replay Splash Screen',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SplashScreen()),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SpaceStarfieldBackground(
        child: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: CyberpunkTheme.cardDark.withOpacity(0.95),
          border: const Border(
            top: BorderSide(color: CyberpunkTheme.neonBlue, width: 1.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          selectedItemColor: CyberpunkTheme.neonBlue,
          unselectedItemColor: CyberpunkTheme.textMuted,
          selectedLabelStyle: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.orbitron(fontSize: 9),
          onTap: (idx) => setState(() => _currentIndex = idx),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_rounded),
              label: 'Admin Panel',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: CyberpunkTheme.bgDark,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFFFF0055)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: CyberpunkTheme.neonBlue,
                  child: Icon(Icons.person, color: Colors.black, size: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  'OPERATOR CYBER',
                  style: GoogleFonts.orbitron(
                      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'STATUS: ONLINE // ROOT ACCESS',
                  style: GoogleFonts.rajdhani(
                      fontSize: 12, color: CyberpunkTheme.neonBlue),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.grid_view_rounded, color: CyberpunkTheme.neonBlue),
            title: const Text('Dashboard (Menu Utama)'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white70),
            title: const Text('Settings (Pengaturan)'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.security, color: CyberpunkTheme.neonRed),
            title: const Text('Admin Panel (Rahasia)'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 2);
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.replay_rounded, color: Colors.amber),
            title: const Text('Putar Ulang Splash Sasuke'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SplashScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 6. DASHBOARD SCREEN (7 PANEL FITUR SESUAI INSTRUKSI)
// ============================================================================

class DashboardScreenTab extends StatelessWidget {
  const DashboardScreenTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      children: const [
        // 1. Bot Generator
        BotGeneratorWidget(),
        SizedBox(height: 14),

        // 2. AI Assistant Panel
        AiAssistantWidget(),
        SizedBox(height: 14),

        // 3. URL Security Checker
        UrlSecurityWidget(),
        SizedBox(height: 14),

        // 4. Send URL Panel
        SendUrlWidget(),
        SizedBox(height: 14),

        // 5. Music Player Widget
        MusicPlayerWidget(),
        SizedBox(height: 14),

        // 6. Find User Tracker
        FindUserWidget(),
        SizedBox(height: 14),

        // 7. Test Wifi Speed & Ping
        WifiTestWidget(),
        SizedBox(height: 24),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// Widget 1: Bot Generator Panel
// ----------------------------------------------------------------------------
class BotGeneratorWidget extends StatefulWidget {
  const BotGeneratorWidget({super.key});

  @override
  State<BotGeneratorWidget> createState() => _BotGeneratorWidgetState();
}

class _BotGeneratorWidgetState extends State<BotGeneratorWidget> {
  String _selectedPlatform = 'WhatsApp';
  final TextEditingController _nameController = TextEditingController(text: 'CyberGuard_Bot');
  String _generatedStatus = '';

  void _generateBot() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      final tokenHex = Random().nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
      _generatedStatus = 'Bot $name berhasil dibuat untuk $_selectedPlatform!\nToken: ak_bot_$tokenHex\nWebhook: https://api.cyberpulse.space/hooks/$_selectedPlatform';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: CyberpunkTheme.neonCard(borderColor: CyberpunkTheme.neonBlue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.smart_toy_outlined, color: CyberpunkTheme.neonBlue),
              const SizedBox(width: 8),
              Text(
                'BOT GENERATOR PANEL',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedPlatform,
            dropdownColor: CyberpunkTheme.cardDark,
            decoration: const InputDecoration(
              labelText: 'Pilih Platform Bot',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp Bot (Baileys/Multi-Device)')),
              DropdownMenuItem(value: 'Telegram', child: Text('Telegram Bot (MTProto Gateway)')),
              DropdownMenuItem(value: 'Discord', child: Text('Discord Bot (Gateway v10)')),
            ],
            onChanged: (val) => setState(() => _selectedPlatform = val!),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama / Identifier Bot',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: CyberpunkTheme.neonBlue,
              foregroundColor: Colors.black,
            ),
            icon: const Icon(Icons.terminal),
            label: const Text('GENERATE CONFIG & TOKEN'),
            onPressed: _generateBot,
          ),
          if (_generatedStatus.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: CyberpunkTheme.neonBlue.withOpacity(0.4)),
              ),
              child: Text(
                _generatedStatus,
                style: GoogleFonts.firaCode(fontSize: 11, color: Colors.cyanAccent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Widget 2: AI Assistant Panel
// ----------------------------------------------------------------------------
class AiAssistantWidget extends StatefulWidget {
  const AiAssistantWidget({super.key});

  @override
  State<AiAssistantWidget> createState() => _AiAssistantWidgetState();
}

class _AiAssistantWidgetState extends State<AiAssistantWidget> {
  final TextEditingController _promptController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'text': 'Sistem AI CyberPulse aktif. Ada yang bisa dibantu, Operator?'}
  ];

  void _sendMessage() {
    final query = _promptController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': query});
      _promptController.clear();
      // Simulasi AI Response
      Timer(const Duration(milliseconds: 600), () {
        setState(() {
          _messages.add({
            'role': 'ai',
            'text': 'Analisis query [$query] selesai: Protokol aman, node enkripsi SHA-256 berjalan optimal.'
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: CyberpunkTheme.neonCard(borderColor: Colors.purpleAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined, color: Colors.purpleAccent),
              const SizedBox(width: 8),
              Text(
                'AI ASSISTANT PANEL',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 120,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
            ),
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, idx) {
                final m = _messages[idx];
                final isUser = m['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.purple.shade900 : Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      m['text']!,
                      style: GoogleFonts.rajdhani(fontSize: 12, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promptController,
                  decoration: const InputDecoration(
                    hintText: 'Tanyakan sesuatu ke AI...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: Colors.purpleAccent),
                icon: const Icon(Icons.send, color: Colors.black, size: 18),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Widget 3: URL Security Checker
// ----------------------------------------------------------------------------
class UrlSecurityWidget extends StatefulWidget {
  const UrlSecurityWidget({super.key});

  @override
  State<UrlSecurityWidget> createState() => _UrlSecurityWidgetState();
}

class _UrlSecurityWidgetState extends State<UrlSecurityWidget> {
  final TextEditingController _urlController = TextEditingController(text: 'https://cyberpulse.space');
  String _securityResult = 'Status: Terverifikasi Aman (SSL 256-Bit Aktif)';

  void _checkSecurity() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    setState(() {
      if (url.startsWith('https://')) {
        _securityResult = '✅ Aman! $url lulus inspeksi keamanan TLS 1.3.';
      } else {
        _securityResult = '⚠️ Peringatan: $url tidak menggunakan enkripsi HTTPS!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: CyberpunkTheme.neonCard(borderColor: Colors.tealAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security, color: Colors.tealAccent),
              const SizedBox(width: 8),
              Text(
                'URL SECURITY CHECKER',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Masukkan URL untuk diperiksa',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
            icon: const Icon(Icons.verified_user),
            label: const Text('SCAN URL SECURITY'),
            onPressed: _checkSecurity,
          ),
          const SizedBox(height: 8),
          Text(_securityResult, style: GoogleFonts.rajdhani(color: Colors.tealAccent)),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Widget 4: Send URL Panel
// ----------------------------------------------------------------------------
class SendUrlWidget extends StatefulWidget {
  const SendUrlWidget({super.key});

  @override
  State<SendUrlWidget> createState() => _SendUrlWidgetState();
}

class _SendUrlWidgetState extends State<SendUrlWidget> {
  final TextEditingController _targetUrlController = TextEditingController(text: 'https://github.com');
  String _sentStatus = '';

  void _sendUrl() {
    final url = _targetUrlController.text.trim();
    if (url.isEmpty) return;
    setState(() {
      _sentStatus = 'Tautan $url berhasil dikirim ke gateway transmisi!';
    });
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tautan berhasil disalin ke clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: CyberpunkTheme.neonCard(borderColor: Colors.blueAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.send_rounded, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(
                'SEND URL PANEL',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _targetUrlController,
            decoration: const InputDecoration(
              labelText: 'Target URL untuk Dikirim / Dibagikan',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
            icon: const Icon(Icons.share),
            label: const Text('KIRIM & SALIN TAUTAN'),
            onPressed: _sendUrl,
          ),
          if (_sentStatus.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(_sentStatus, style: GoogleFonts.rajdhani(color: Colors.lightBlueAccent)),
          ],
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Widget 5: Music Player Widget (Monolog, Love Story, World Violence)
// ----------------------------------------------------------------------------
class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({super.key});

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  final List<String> _songs = ['Monolog', 'Love Story', 'World Violence'];
  int _currentSongIndex = 0;
  bool _isPlaying = false;

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
  }

  void _nextSong() {
    setState(() {
      _currentSongIndex = (_currentSongIndex + 1) % _songs.length;
    });
  }

  void _prevSong() {
    setState(() {
      _currentSongIndex = (_currentSongIndex - 1 + _songs.length) % _songs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: CyberpunkTheme.neonCard(borderColor: Colors.pinkAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.music_note, color: Colors.pinkAccent),
              const SizedBox(width: 8),
              Text(
                'MINI MUSIC PLAYER // AUDIO MATRIX',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.pinkAccent.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _songs[_currentSongIndex],
                      style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      _isPlaying ? 'Status: Playing Audio...' : 'Status: Paused',
                      style: GoogleFonts.rajdhani(color: Colors.pinkAccent),
                    ),
                  ],
                ),
                Icon(
                  _isPlaying ? Icons.graphic_eq : Icons.pause_circle_outline,
                  color: Colors.pinkAccent,
                  size: 28,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: _prevSong,
              ),
              IconButton(
                iconSize: 36,
                icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.pinkAccent),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _nextSong,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Widget 6: Find User Tracker
// ----------------------------------------------------------------------------
class FindUserWidget extends StatefulWidget {
  const FindUserWidget({super.key});

  @override
  State<FindUserWidget> createState() => _FindUserWidgetState();
}

class _FindUserWidgetState extends State<FindUserWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _foundUserData = 'ID: #CYB-7749\nUsername: @ardi_nexus\nStatus: Online\nIP: 192.168.10.42\nPing: 12ms';

  void _searchUser() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    setState(() {
      final randPing = Random().nextInt(30) + 10;
      final randIp = '192.168.${Random().nextInt(254)}.${Random().nextInt(254)}';
      _foundUserData = 'ID: #${query.toUpperCase()}\nUsername: @$query\nStatus: Online\nIP: $randIp\nPing: ${randPing}ms';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: CyberpunkTheme.neonCard(borderColor: Colors.amberAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_search, color: Colors.amberAccent),
              const SizedBox(width: 8),
              Text(
                'FIND USER // TRACKER',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari ID atau Username...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amberAccent, foregroundColor: Colors.black),
                onPressed: _searchUser,
                child: const Text('CARI'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.amberAccent.withOpacity(0.3)),
            ),
            child: Text(
              _foundUserData,
              style: GoogleFonts.firaCode(fontSize: 11, color: Colors.amberAccent),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// Widget 7: Test Wifi Speed & Ping
// ----------------------------------------------------------------------------
class WifiTestWidget extends StatefulWidget {
  const WifiTestWidget({super.key});

  @override
  State<WifiTestWidget> createState() => _WifiTestWidgetState();
}

class _WifiTestWidgetState extends State<WifiTestWidget> {
  bool _isTesting = false;
  int _ping = 14;
  double _downloadSpeed = 128.4;
  double _uploadSpeed = 64.2;

  void _runSpeedTest() {
    setState(() => _isTesting = true);
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _isTesting = false;
        _ping = Random().nextInt(15) + 8;
        _downloadSpeed = (Random().nextDouble() * 100 + 80);
        _uploadSpeed = (Random().nextDouble() * 50 + 40);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: CyberpunkTheme.neonCard(borderColor: CyberpunkTheme.neonRed),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wifi, color: CyberpunkTheme.neonRed),
              const SizedBox(width: 8),
              Text(
                'TEST WIFI & NETWORK PING',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('PING', style: GoogleFonts.orbitron(fontSize: 10, color: Colors.grey)),
                  Text('$_ping ms', style: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  Text('DOWNLOAD', style: GoogleFonts.orbitron(fontSize: 10, color: Colors.grey)),
                  Text('${_downloadSpeed.toStringAsFixed(1)} Mbps', style: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.bold, color: CyberpunkTheme.neonBlue)),
                ],
              ),
              Column(
                children: [
                  Text('UPLOAD', style: GoogleFonts.orbitron(fontSize: 10, color: Colors.grey)),
                  Text('${_uploadSpeed.toStringAsFixed(1)} Mbps', style: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.bold, color: CyberpunkTheme.neonRed)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: CyberpunkTheme.neonRed,
              foregroundColor: Colors.white,
            ),
            icon: _isTesting
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.speed),
            label: Text(_isTesting ? 'TESTING NETWORK...' : 'START SPEEDTEST'),
            onPressed: _isTesting ? null : _runSpeedTest,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 7. SETTINGS SCREEN TAB
// ============================================================================

class SettingsScreenTab extends StatefulWidget {
  const SettingsScreenTab({super.key});

  @override
  State<SettingsScreenTab> createState() => _SettingsScreenTabState();
}

class _SettingsScreenTabState extends State<SettingsScreenTab> {
  bool _isNeonMode = true;
  String _cacheSize = '142.8 MB';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Header Profil
        Container(
          padding: const EdgeInsets.all(14),
          decoration: CyberpunkTheme.neonCard(borderColor: CyberpunkTheme.neonBlue),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: CyberpunkTheme.neonBlue,
                child: Icon(Icons.person, color: Colors.black, size: 30),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Operator Ardiansyah', style: GoogleFonts.orbitron(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('@ardi_nexus • #CYB-7749', style: GoogleFonts.rajdhani(color: CyberpunkTheme.neonBlue)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 1. Edit Profil
        _buildTile(
          icon: Icons.edit_note,
          color: CyberpunkTheme.neonBlue,
          title: 'Edit Profil',
          subtitle: 'Ubah nama dan kredensial operator',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dialog Edit Profil dibuka')));
          },
        ),
        const SizedBox(height: 10),

        // 2. Toggle Dark / Neon Mode
        Container(
          decoration: CyberpunkTheme.neonCard(borderColor: _isNeonMode ? CyberpunkTheme.neonBlue : Colors.white24),
          child: SwitchListTile(
            secondary: Icon(Icons.electric_bolt, color: _isNeonMode ? CyberpunkTheme.neonBlue : Colors.grey),
            title: const Text('Toggle Dark / Neon Mode'),
            subtitle: Text(_isNeonMode ? 'Neon Glow: Aktif' : 'Dark Stealth: Redup'),
            value: _isNeonMode,
            activeColor: CyberpunkTheme.neonBlue,
            onChanged: (val) => setState(() => _isNeonMode = val),
          ),
        ),
        const SizedBox(height: 10),

        // 3. Clear Cache
        _buildTile(
          icon: Icons.cleaning_services,
          color: Colors.amber,
          title: 'Clear Cache',
          subtitle: 'Ukuran penyimpanan sementara: $_cacheSize',
          onTap: () {
            setState(() => _cacheSize = '0 KB');
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache berhasil dibersihkan!')));
          },
        ),
        const SizedBox(height: 10),

        // 4. Log Out
        _buildTile(
          icon: Icons.power_settings_new,
          color: CyberpunkTheme.neonRed,
          title: 'Log Out',
          subtitle: 'Keluar dan kunci sesi terminal',
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildTile({required IconData icon, required Color color, required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      decoration: CyberpunkTheme.neonCard(borderColor: color),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CyberpunkTheme.cardDark,
        title: const Text('Konfirmasi Logout', style: TextStyle(color: CyberpunkTheme.neonRed)),
        content: const Text('Apakah Anda yakin ingin keluar dari CyberPulse?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('BATAL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CyberpunkTheme.neonRed),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
            },
            child: const Text('YA, KELUAR'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 8. ADMIN PANEL SCREEN TAB (KICK, GENERATE, DELETE DENGAN POP-UP)
// ============================================================================

class AdminPanelScreenTab extends StatefulWidget {
  const AdminPanelScreenTab({super.key});

  @override
  State<AdminPanelScreenTab> createState() => _AdminPanelScreenTabState();
}

class _AdminPanelScreenTabState extends State<AdminPanelScreenTab> {
  final TextEditingController _kickTargetController = TextEditingController();
  final List<String> _members = [
    'ShadowRider (#MEM-9021)',
    'NeonSamurai (#MEM-4019)',
    'GlitchPhantom (#MEM-3120)',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 1. KICK MEMBER (DENGAN INPUT KOLOM NAMA)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: CyberpunkTheme.neonCard(borderColor: Colors.orangeAccent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KICK MEMBER DARI SISTEM',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _kickTargetController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama / ID member untuk di-kick...',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.black),
                icon: const Icon(Icons.person_remove),
                label: const Text('KICK MEMBER SEKARANG'),
                onPressed: () {
                  final target = _kickTargetController.text.trim();
                  if (target.isNotEmpty) {
                    setState(() {
                      _members.removeWhere((m) => m.toLowerCase().contains(target.toLowerCase()));
                    });
                    _kickTargetController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Member "$target" berhasil di-kick dari sistem!')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 2. GENERATE AKUN MEMBER (RANDOM GENERATOR)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: CyberpunkTheme.neonCard(borderColor: CyberpunkTheme.neonBlue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GENERATE AKUN MEMBER (ACAK)',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: CyberpunkTheme.neonBlue),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: CyberpunkTheme.neonBlue, foregroundColor: Colors.black),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('GENERATE AKUN MEMBER BARU'),
                onPressed: () {
                  final randNum = Random().nextInt(8999) + 1000;
                  final newMember = 'CyberOperative_$randNum (#MEM-$randNum)';
                  setState(() => _members.insert(0, newMember));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Akun $newMember berhasil digenerate!')),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 3. DELETE AKUN MEMBER (DISERTAI POP-UP KONFIRMASI)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: CyberpunkTheme.neonCard(borderColor: CyberpunkTheme.neonRed),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DELETE AKUN MEMBER',
                style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: CyberpunkTheme.neonRed),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: CyberpunkTheme.neonRed, foregroundColor: Colors.white),
                icon: const Icon(Icons.delete_forever),
                label: const Text('DELETE AKUN MEMBER (POP-UP)'),
                onPressed: () => _showDeleteConfirmDialog(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Daftar Member Aktif
        Text('DAFTAR MEMBER AKTIF (${_members.length})', style: GoogleFonts.orbitron(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        ..._members.map((m) => Card(
              color: CyberpunkTheme.cardDark,
              child: ListTile(
                leading: const Icon(Icons.person, color: CyberpunkTheme.neonBlue),
                title: Text(m, style: const TextStyle(fontSize: 13)),
              ),
            )),
      ],
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CyberpunkTheme.cardDark,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: CyberpunkTheme.neonRed, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'KONFIRMASI HAPUS AKUN',
          style: TextStyle(color: CyberpunkTheme.neonRed, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Peringatan Kritis! Apakah Anda yakin ingin menghapus akun member ini secara permanen dari basis data?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('BATAL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CyberpunkTheme.neonRed),
            onPressed: () {
              Navigator.pop(ctx);
              if (_members.isNotEmpty) {
                final deleted = _members.removeLast();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Akun "$deleted" telah dihapus secara permanen!')),
                );
              }
            },
            child: const Text('HAPUS SEKARANG'),
          ),
        ],
      ),
    );
  }
}

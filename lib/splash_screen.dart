import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _slideController;
  late AnimationController _floatController;
  late AnimationController _glowController;
  late AnimationController _particleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _particleAnimation;

  int currentSlide = 0;
  late Timer _slideTimer;

  // Deep blue palette with white accents
  final Color deepBlue = const Color(0xFF0D47A1);
  final Color mediumBlue = const Color(0xFF1976D2);
  final Color accentBlue = const Color(0xFF64B5F6);
  final Color pureWhite = const Color(0xFFFFFFFF);
  final Color softWhite = const Color(0xFFF8FBFF);
  final Color darkText = const Color(0xFF0A2540);

  final List<SlideContent> slides = [
    SlideContent(
      icon: Icons.favorite,
      title: 'OncoSoul',
      subtitle: 'Your companion in the journey',
    ),
    SlideContent(
      icon: Icons.psychology_outlined,
      title: 'We Understand',
      subtitle: 'Supporting you every step',
    ),
    SlideContent(
      icon: Icons.volunteer_activism,
      title: 'Together Strong',
      subtitle: 'A caring community awaits',
    ),
  ];

  // Hospital/Medical related icons for background
  final List<IconData> medicalIcons = [
    Icons.medical_services_outlined,
    Icons.local_hospital_outlined,
    Icons.health_and_safety_outlined,
    Icons.medication_outlined,
    Icons.monitor_heart_outlined,
    Icons.biotech_outlined,
    Icons.vaccines_outlined,
    Icons.science_outlined,
  ];

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOutBack,
      ),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _floatAnimation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _particleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.easeInOut,
      ),
    );

    _mainController.forward();
    _slideController.forward();
    _floatController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
    _particleController.repeat(reverse: true);

    _slideTimer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      if (mounted) {
        setState(() {
          currentSlide = (currentSlide + 1) % slides.length;
        });
        _slideController.reset();
        _slideController.forward();
      }
    });

    Timer(const Duration(seconds: 9), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  )),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _slideTimer.cancel();
    _mainController.dispose();
    _slideController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              softWhite,
              accentBlue.withOpacity(0.2),
              mediumBlue.withOpacity(0.5),
              deepBlue,
            ],
            stops: const [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Medical-themed white particles floating
            AnimatedBuilder(
              animation: _particleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: size,
                  painter: MedicalParticlePainter(
                    animation: _particleAnimation.value,
                  ),
                );
              },
            ),

            // Hospital/Medical themed floating background icons
            ...List.generate(8, (index) {
              return AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  final isEven = index % 2 == 0;
                  return Positioned(
                    left: (index % 3) * size.width / 2.5 + (index % 2 == 0 ? -20 : 20),
                    top: (index ~/ 3) * size.height / 3 + 
                        _floatAnimation.value * (isEven ? 1 : -1),
                    child: Opacity(
                      opacity: 0.04,
                      child: Transform.rotate(
                        angle: (index * math.pi / 6),
                        child: Icon(
                          medicalIcons[index % medicalIcons.length],
                          size: 85 + (index * 10.0),
                          color: deepBlue,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Medical cross symbols in background
            Positioned(
              top: size.height * 0.15,
              right: size.width * 0.15,
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_floatAnimation.value * 0.3, _floatAnimation.value * 0.5),
                    child: Opacity(
                      opacity: 0.05,
                      child: Icon(
                        Icons.add_box_outlined,
                        size: 120,
                        color: pureWhite,
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: size.height * 0.2,
              left: size.width * 0.1,
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_floatAnimation.value * -0.4, _floatAnimation.value * 0.3),
                    child: Opacity(
                      opacity: 0.06,
                      child: Icon(
                        Icons.local_hospital,
                        size: 100,
                        color: pureWhite,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Large white decorative circles
            Positioned(
              top: -120,
              right: -80,
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_floatAnimation.value * 0.4, _floatAnimation.value * 0.6),
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            pureWhite.withOpacity(0.3),
                            pureWhite.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: -140,
              left: -100,
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_floatAnimation.value * -0.5, _floatAnimation.value * 0.3),
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            pureWhite.withOpacity(0.25),
                            pureWhite.withOpacity(0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Medical pulse/heartbeat wave decoration
            Positioned(
              top: size.height * 0.4,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _particleAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: 0.04,
                    child: CustomPaint(
                      size: Size(size.width, 60),
                      painter: HeartbeatWavePainter(
                        animation: _particleAnimation.value,
                        color: pureWhite,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Additional small white circles with medical theme
            Positioned(
              top: size.height * 0.25,
              left: 40,
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pureWhite.withOpacity(0.15 * _glowAnimation.value),
                      boxShadow: [
                        BoxShadow(
                          color: pureWhite.withOpacity(0.2 * _glowAnimation.value),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.medical_information_outlined,
                        size: 30,
                        color: deepBlue.withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: size.height * 0.3,
              right: 50,
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pureWhite.withOpacity(0.12 * _glowAnimation.value),
                      boxShadow: [
                        BoxShadow(
                          color: pureWhite.withOpacity(0.18 * _glowAnimation.value),
                          blurRadius: 25,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite_border,
                        size: 35,
                        color: deepBlue.withOpacity(0.25),
                      ),
                    ),
                  );
                },
              ),
            ),

            // White curved accent at top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value * 0.2),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            pureWhite.withOpacity(0.4),
                            pureWhite.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      const Spacer(flex: 3),

                      // Glowing icon container with enhanced white glow
                      AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: pureWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: pureWhite.withOpacity(0.6 * _glowAnimation.value),
                                  blurRadius: 40,
                                  spreadRadius: 12,
                                ),
                                BoxShadow(
                                  color: accentBlue.withOpacity(0.4 * _glowAnimation.value),
                                  blurRadius: 50,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: pureWhite.withOpacity(0.8),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 700),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Icon(
                                  slides[currentSlide].icon,
                                  key: ValueKey(currentSlide),
                                  size: 75,
                                  color: deepBlue,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 50),

                      // Sliding content
                      SizedBox(
                        height: 115,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _slideController,
                            child: Column(
                              children: [
                                Text(
                                  slides[currentSlide].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w800,
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: [
                                          darkText,
                                          deepBlue,
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(0, 0, 200, 70),
                                      ),
                                    letterSpacing: 0.8,
                                    height: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: pureWhite.withOpacity(0.3),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 26,
                                    vertical: 11,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: LinearGradient(
                                      colors: [
                                        pureWhite.withOpacity(0.45),
                                        pureWhite.withOpacity(0.25),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: pureWhite.withOpacity(0.6),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: pureWhite.withOpacity(0.2),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    slides[currentSlide].subtitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: darkText.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 42),

                      // Enhanced slide indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          slides.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: currentSlide == index ? 35 : 9,
                            height: 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: currentSlide == index
                                  ? LinearGradient(
                                      colors: [deepBlue, mediumBlue],
                                    )
                                  : null,
                              color: currentSlide != index
                                  ? pureWhite.withOpacity(0.5)
                                  : null,
                              boxShadow: currentSlide == index
                                  ? [
                                      BoxShadow(
                                        color: deepBlue.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: pureWhite.withOpacity(0.3),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      // Loading section
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 34,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              pureWhite.withOpacity(0.35),
                              pureWhite.withOpacity(0.2),
                            ],
                          ),
                          border: Border.all(
                            color: pureWhite.withOpacity(0.5),
                            width: 1.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: pureWhite.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  deepBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Preparing your experience',
                              style: TextStyle(
                                fontSize: 14,
                                color: darkText.withOpacity(0.95),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Bottom tagline
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: pureWhite.withOpacity(0.25),
                          border: Border.all(
                            color: pureWhite.withOpacity(0.4),
                            width: 1.3,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Comprehensive Cancer Care',
                              style: TextStyle(
                                fontSize: 13,
                                color: darkText.withOpacity(0.85),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 13,
                                  color: deepBlue.withOpacity(0.8),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Hope • Care • Heal',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: deepBlue.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
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

class SlideContent {
  final IconData icon;
  final String title;
  final String subtitle;

  SlideContent({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// Medical-themed particle painter
class MedicalParticlePainter extends CustomPainter {
  final double animation;

  MedicalParticlePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Small medical cross particles
    final particles = [
      _Particle(0.15, 0.2, 4, true),
      _Particle(0.85, 0.15, 5, false),
      _Particle(0.2, 0.65, 3.5, true),
      _Particle(0.78, 0.7, 4.5, false),
      _Particle(0.5, 0.35, 3, true),
      _Particle(0.35, 0.8, 5.5, false),
      _Particle(0.65, 0.45, 4, true),
      _Particle(0.9, 0.88, 3.5, false),
    ];

    for (var particle in particles) {
      final offset = Offset(
        size.width * particle.x,
        size.height * particle.y + (animation * 15 - 7.5),
      );

      if (particle.isCross) {
        // Draw small medical cross
        paint.color = const Color(0xFFFFFFFF).withOpacity(0.12 + animation * 0.08);
        final crossSize = particle.radius * 2;
        canvas.drawRect(
          Rect.fromCenter(center: offset, width: crossSize / 3, height: crossSize),
          paint,
        );
        canvas.drawRect(
          Rect.fromCenter(center: offset, width: crossSize, height: crossSize / 3),
          paint,
        );
      } else {
        // Draw circle
        paint.color = const Color(0xFFFFFFFF).withOpacity(0.15 + animation * 0.1);
        canvas.drawCircle(offset, particle.radius, paint);

        paint.color = const Color(0xFFFFFFFF).withOpacity(0.08 + animation * 0.05);
        canvas.drawCircle(offset, particle.radius * 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(MedicalParticlePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

// Heartbeat wave painter
class HeartbeatWavePainter extends CustomPainter {
  final double animation;
  final Color color;

  HeartbeatWavePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final offset = size.width * animation;

    path.moveTo(0, size.height / 2);

    for (double x = 0; x < size.width + 50; x += 50) {
      final adjustedX = x - offset;
      if (adjustedX > 0 && adjustedX < size.width) {
        path.lineTo(adjustedX, size.height / 2);
        path.lineTo(adjustedX + 5, size.height / 2 - 15);
        path.lineTo(adjustedX + 10, size.height / 2 + 15);
        path.lineTo(adjustedX + 15, size.height / 2 - 8);
        path.lineTo(adjustedX + 20, size.height / 2);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HeartbeatWavePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class _Particle {
  final double x;
  final double y;
  final double radius;
  final bool isCross;

  _Particle(this.x, this.y, this.radius, this.isCross);
}
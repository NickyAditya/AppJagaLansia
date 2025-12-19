import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _authService = AuthService();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Logout button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Color(0xFF00897B)),
                    onPressed: () async {
                      await _authService.logout();
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                  _buildPage4(),
                  _buildPage5(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 5,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Color(0xFF5D4037),
                  dotColor: Color(0xFFD7CCC8),
                  expansionFactor: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Page 1 - Selamat datang di Jaga Lansia (pasted_image_3.png style)
  Widget _buildPage1() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Icon at top
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF00897B),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          // Title
          const Text(
            'Selamat datang di',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00897B),
              letterSpacing: 0.5,
            ),
          ),
          const Text(
            'Jaga Lansia',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00897B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 15),
          // Subtitle
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Jaga Orang tuamu dimana pun dan\nkapanpun🍃',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Robot Image
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Image.asset(
                'assets/robot_guard.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Decorative icons around the main character
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFloatingIcon(Icons.show_chart, Colors.orange),
                            const SizedBox(width: 60),
                            _buildFloatingIcon(Icons.flash_on, Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Main character
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8BC34A),
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Face
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '😊',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                              // Badge
                              Positioned(
                                bottom: 50,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black54, width: 2),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.circle, size: 12),
                                      SizedBox(width: 5),
                                      Text('—', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFloatingIcon(Icons.search, Colors.orange),
                            const SizedBox(width: 60),
                            _buildFloatingIcon(Icons.description, Colors.orange),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mulai',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  // Page 2 - Jaga Lansia Membantu (pasted_image_4.png style)
  Widget _buildPage2() {
    return _buildVectorPage(
      'assets/vector1.png',
      'Jaga Lansia Membantu\nMenjaga Orang Tuamu',
      const Color(0xFFF1F8E9),
      const Color(0xFFDCEDC8),
    );
  }

  Widget _buildPage3() {
    return _buildVectorPage(
      'assets/vector2.png',
      'Tidak Perlu Khawatir\nLagi Jauh dari\nOrangtuamu',
      const Color(0xFFFFF3E0),
      const Color(0xFFFFE0B2),
    );
  }

  Widget _buildPage4() {
    return _buildVectorPage(
      'assets/vector3.png',
      'Dilengkapi Dengan AI\nUntuk Menjaga\nOrangtuamu',
      const Color(0xFFF3E5F5),
      const Color(0xFFE1BEE7),
    );
  }

  Widget _buildPage5() {
    return _buildVectorPage(
      'assets/vector4.png',
      'Bersama Jaga Lansia\nMenjaga Orangtuamu',
      const Color(0xFFE3F2FD),
      const Color(0xFFBBDEFB),
      isLast: true,
    );
  }

  Widget _buildVectorPage(
    String imagePath,
    String title,
    Color bgColor,
    Color imageBgColor, {
    bool isLast = false,
  }) {
    return Container(
      color: bgColor,
      child: Column(
        children: [
          // Image section - Made bigger with less padding
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Container(
                  color: imageBgColor,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback illustration
                      return _buildFallbackIllustration();
                    },
                  ),
                ),
              ),
            ),
          ),
          // Title section - Made smaller
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator space
                  const SizedBox(height: 10),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5D4037),
                        height: 1.3,
                      ),
                    ),
                  ),
                  // Button
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5D4037),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (isLast) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackIllustration() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF8D6E63),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.elderly,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 150,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF81C784),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
    );
  }
}

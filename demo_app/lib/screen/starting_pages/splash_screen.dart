import 'package:demo_app/data/color.dart';
import 'package:demo_app/screen/starting_pages/language_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _arrowController;
  late AnimationController _slideController;
  late Animation<double> _arrowAnimation;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isSliding = false;
  double _dragDistance = 0;
  final double _maxDragDistance = 200;

  @override
  void initState() {
    super.initState();

    _arrowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _arrowAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 10000),
    );

    _slideAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _colorAnimation = ColorTween(
      begin: primary_colour,
      end: Colors.black,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _arrowController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _startSlideAnimation() {
    setState(() {
      _isSliding = true;
    });
    _arrowController.stop();
    _slideController.forward().then((_) {
      _goToHome();
    });
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LanguageScreen()),
    );
  }

  void _handleDragUpdate(double deltaY) {
    if (!_isSliding) {
      setState(() {
        _dragDistance = (_dragDistance - deltaY).clamp(0, _maxDragDistance);
      });

      double progress = _dragDistance / _maxDragDistance;
      _slideController.value = progress;

      if (_dragDistance >= _maxDragDistance) {
        _startSlideAnimation();
      }
    }
  }

  void _handleDragEnd(double velocity) {
    if (!_isSliding) {
      if (velocity < -1000 || _dragDistance > _maxDragDistance * 0.6) {
        _startSlideAnimation();
      } else if (velocity > 1000 || _dragDistance < _maxDragDistance * 0.3) {
        _slideController.animateTo(0, duration: Duration(milliseconds: 300));
        setState(() {
          _dragDistance = 0;
        });
      } else {
        if (_dragDistance > _maxDragDistance * 0.5) {
          _startSlideAnimation();
        } else {
          _slideController.animateTo(0, duration: Duration(milliseconds: 300));
          setState(() {
            _dragDistance = 0;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        _handleDragUpdate(details.delta.dy);
      },
      onVerticalDragEnd: (details) {
        _handleDragEnd(details.primaryVelocity ?? 0);
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_slideController, _arrowController]),
        builder: (context, child) {
          return Scaffold(
            backgroundColor: _colorAnimation.value ?? primary_colour,
            body: SafeArea(
              child: Transform.translate(
                offset: Offset(
                  0,
                  -_slideAnimation.value * MediaQuery.of(context).size.height,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Opacity(
                        opacity: 1 - (_slideAnimation.value * 0.8),
                        child: Transform.scale(
                          scale: 1 - (_slideAnimation.value * 0.3),
                          child: Image.asset(
                            'asset/image/logo_bg_black.jpg',
                            width: 300,
                            height: 300,
                          ),
                        ),
                      ),
                    ),
                    if (!_isSliding || _slideAnimation.value < 0.5)
                      Positioned(
                        bottom: 30 + (_dragDistance * 0.5),
                        left: 0,
                        right: 0,
                        child: Opacity(
                          opacity: 1 - (_slideAnimation.value * 2).clamp(0, 1),
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              _isSliding ? 0 : -_arrowAnimation.value,
                            ),
                            child: Column(
                              children: [
                                AnimatedRotation(
                                  turns: _dragDistance > _maxDragDistance * 0.8
                                      ? 0.5
                                      : 0,
                                  duration: Duration(milliseconds: 200),
                                  child: Icon(
                                    _dragDistance > _maxDragDistance * 0.8
                                        ? Icons.keyboard_double_arrow_up
                                        : Icons.keyboard_arrow_up,
                                    size: 40 + (_dragDistance * 0.1),
                                    color: secondary_colour_70.withOpacity(
                                      1 - (_slideAnimation.value * 0.5),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                AnimatedSwitcher(
                                  duration: Duration(milliseconds: 200),
                                  child: Text(
                                    _dragDistance > _maxDragDistance * 0.8
                                        ? "Release to Continue"
                                        : _dragDistance > 0
                                        ? "Keep Sliding Up"
                                        : "Swipe Up",
                                    key: ValueKey(
                                      _dragDistance > _maxDragDistance * 0.8
                                          ? "release"
                                          : _dragDistance > 0
                                          ? "sliding"
                                          : "swipe",
                                    ),
                                    style: TextStyle(
                                      fontSize: 16 + (_dragDistance * 0.02),
                                      color: secondary_colour_70.withOpacity(
                                        1 - (_slideAnimation.value * 0.5),
                                      ),
                                      fontWeight:
                                          _dragDistance > _maxDragDistance * 0.5
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:animater/screen/login-animations/success_page.dart';
import 'package:flutter/material.dart';
import 'animated_background.dart';
import 'animated_text_field.dart';
import 'loading_button.dart';
import 'shake_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late final AnimationController _enter; // plays once: staggered entrance
  late final AnimationController _float; // loops forever: floating logo
  late final List<Animation<double>> _steps;
  late final Animation<double> _logoScale;

  final _shake = GlobalKey<ShakeWidgetState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isLogin = true;
  String? _nameError;
  String? _emailError;
  String? _passError;
  SubmitState _state = SubmitState.idle;

  @override
  void initState() {
    super.initState();

    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    // 8 staggered slots. Item i starts at i * 0.08 and lasts 40% of the timeline.
    _steps = List.generate(8, (i) {
      final start = i * 0.08;
      return CurvedAnimation(
        parent: _enter,
        curve: Interval(start, start + 0.4, curve: Curves.easeOutCubic),
      );
    });

    _logoScale = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _enter.dispose();
    _float.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Wraps a widget with fade + slide-up using slot i of the stagger.
  Widget _stagger(int i, Widget child) {
    return FadeTransition(
      opacity: _steps[i],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(_steps[i]),
        child: child,
      ),
    );
  }

  void _switchMode() {
    setState(() {
      _isLogin = !_isLogin;
      _nameError = _emailError = _passError = null;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final emailOk =
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_email.text.trim());

    setState(() {
      _nameError = (!_isLogin && _name.text.trim().isEmpty)
          ? 'Please enter your name'
          : null;
      _emailError = emailOk ? null : 'Enter a valid email address';
      _passError =
          _password.text.length >= 6 ? null : 'Password needs 6+ characters';
    });

    if (_nameError != null || _emailError != null || _passError != null) {
      _shake.currentState?.shake(); // invalid: shake the form
      return;
    }

    // idle -> loading -> success
    setState(() => _state = SubmitState.loading);
    await Future.delayed(const Duration(seconds: 2)); // pretend network call
    if (!mounted) return;

    setState(() => _state = SubmitState.success);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final who = _isLogin || _name.text.trim().isEmpty
        ? _email.text.split('@').first
        : _name.text.trim();

    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => SuccessPage(name: who),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    );

    // Back from the success page: reset the button
    if (!mounted) return;
    setState(() => _state = SubmitState.idle);
  }

  Widget _logo() {
    return AnimatedBuilder(
      animation: _float,
      builder: (context, child) {
        // Gentle up/down drift
        final dy = -10 * Curves.easeInOut.transform(_float.value);
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: ScaleTransition(
        scale: _logoScale,
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => RotationTransition(
              turns: Tween<double>(begin: 0.8, end: 1.0).animate(anim),
              child: ScaleTransition(scale: anim, child: child),
            ),
            child: Icon(
              _isLogin ? Icons.lock_open_rounded : Icons.person_add_alt_1,
              key: ValueKey(_isLogin),
              size: 46,
              color: Colors.indigo,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _stagger(0, Center(child: _logo())),
                  const SizedBox(height: 28),

                  _stagger(
                    1,
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _isLogin ? 'Welcome back' : 'Create account',
                        key: ValueKey(_isLogin),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _stagger(
                    2,
                    Text(
                      _isLogin
                          ? 'Sign in to continue'
                          : 'Join us, it only takes a minute',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Everything inside ShakeWidget shakes together on error
                  ShakeWidget(
                    key: _shake,
                    child: Column(
                      children: [
                        // Name field exists only in sign-up mode, size animates
                        AnimatedSize(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOut,
                          child: _isLogin
                              ? const SizedBox(width: double.infinity)
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: AnimatedTextField(
                                    controller: _name,
                                    hint: 'Full name',
                                    icon: Icons.person_outline,
                                    errorText: _nameError,
                                    onChanged: (_) =>
                                        setState(() => _nameError = null),
                                  ),
                                ),
                        ),
                        _stagger(
                          3,
                          AnimatedTextField(
                            controller: _email,
                            hint: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            errorText: _emailError,
                            onChanged: (_) =>
                                setState(() => _emailError = null),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _stagger(
                          4,
                          AnimatedTextField(
                            controller: _password,
                            hint: 'Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            errorText: _passError,
                            onChanged: (_) =>
                                setState(() => _passError = null),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _stagger(
                    5,
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  _stagger(
                    6,
                    LoadingButton(
                      label: _isLogin ? 'Sign In' : 'Create Account',
                      state: _state,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _stagger(
                    7,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin
                              ? "Don't have an account?"
                              : 'Already have an account?',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: _state == SubmitState.idle
                              ? _switchMode
                              : null,
                          child: Text(
                            _isLogin ? 'Sign up' : 'Sign in',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
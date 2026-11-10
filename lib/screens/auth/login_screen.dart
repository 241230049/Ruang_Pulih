import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/app_state_service.dart';
import '../main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  final AppStateService appState;

  const LoginScreen({super.key, required this.appState});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // --- Controllers ---
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(text: 'rian.pejuang@gmail.com');
  final _passwordController = TextEditingController(text: 'password123');

  // --- State ---
  UserRole _selectedRole = UserRole.korban;
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  // --- Animation ---
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // --- Role metadata: icon & description per role ---
  static const _roleInfo = {
    UserRole.korban: (
      icon: Icons.favorite_outline,
      desc: 'Saya sedang dalam proses pemulihan',
    ),
    UserRole.volunteer: (
      icon: Icons.volunteer_activism_outlined,
      desc: 'Saya ingin membantu sebagai konselor',
    ),
    UserRole.admin: (
      icon: Icons.admin_panel_settings_outlined,
      desc: 'Kelola platform RuangPulih',
    ),
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---- Validation ----
  String? _validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(val.trim())) return 'Format email tidak valid';
    return null;
  }

  String? _validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Kata sandi tidak boleh kosong';
    if (val.length < 6) return 'Kata sandi minimal 6 karakter';
    return null;
  }

  // ---- Login Handler ----
  Future<void> _handleLogin() async {
    // Tutup keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulasi delay network/auth (ganti dengan logika auth nyata)
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    widget.appState.switchRole(_selectedRole);

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) =>
            MainNavigationScreen(appState: widget.appState),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
      (route) => false,
    );
  }

  // ---- Lupa Kata Sandi ----
  void _showForgotPasswordDialog() {
    final resetController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Reset Kata Sandi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan email terdaftar Anda. Kami akan mengirimkan tautan untuk mereset kata sandi.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: resetController,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'nama@email.com',
                prefixIcon:
                    Icon(Icons.email_outlined, color: AppColors.primary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                          child: Text(
                              'Tautan reset dikirim! Periksa kotak masuk email Anda.')),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Kirim Tautan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Form(
              key: _formKey,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  const SizedBox(height: 12),

                  // ── Header / Branding ──────────────────────────────
                  _buildHeader(),
                  const SizedBox(height: 28),

                  // ── Pilihan Peran ──────────────────────────────────
                  _buildSectionLabel('Masuk Sebagai'),
                  const SizedBox(height: 10),
                  _buildRoleSelector(),
                  const SizedBox(height: 24),

                  // ── Email ─────────────────────────────────────────
                  _buildSectionLabel('Email Pengguna'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    validator: _validateEmail,
                    decoration: const InputDecoration(
                      prefixIcon:
                          Icon(Icons.email_outlined, color: AppColors.primary),
                      hintText: 'nama@email.com',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Kata Sandi ────────────────────────────────────
                  _buildSectionLabel('Kata Sandi'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: _validatePassword,
                    onFieldSubmitted: (_) => _handleLogin(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.primary),
                      hintText: 'Masukkan kata sandi...',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Ingat saya + Lupa sandi ───────────────────────
                  _buildRememberForgotRow(),
                  const SizedBox(height: 28),

                  // ── Tombol Masuk ──────────────────────────────────
                  _buildLoginButton(),
                  const SizedBox(height: 20),

                  // ── Divider ───────────────────────────────────────
                  _buildDivider(),
                  const SizedBox(height: 20),

                  // ── Quick Login Demo ──────────────────────────────
                  _buildQuickDemoSection(),
                  const SizedBox(height: 20),

                  // ── Info Privasi ──────────────────────────────────
                  _buildPrivacyBanner(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════
  // Widget Builders
  // ════════════════════════════════════════════════

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo / Icon
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.healing_rounded, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 16),
        const Text(
          'Selamat Datang\nKembali 👋',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Lanjutkan perjalanan pemulihan Anda. Setiap hari adalah langkah maju.',
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      children: UserRole.values.map((role) {
        final isSelected = _selectedRole == role;
        final info = _roleInfo[role]!;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _selectedRole = role);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryContainer : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    info.icon,
                    size: 18,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.displayName,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        info.desc,
                        style: const TextStyle(
                            fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle,
                      color: AppColors.primary, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRememberForgotRow() {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Checkbox(
            value: _rememberMe,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: (val) => setState(() => _rememberMe = val ?? false),
          ),
        ),
        const SizedBox(width: 8),
        const Text('Ingat saya',
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
        const Spacer(),
        TextButton(
          onPressed: _showForgotPasswordDialog,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Lupa kata sandi?',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.4),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login_rounded, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Masuk ke Aplikasi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'atau masuk cepat sebagai demo',
            style: TextStyle(
                fontSize: 11, color: AppColors.textMuted),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

  Widget _buildQuickDemoSection() {
    final demoAccounts = [
      (role: UserRole.korban, label: 'Demo Pejuang', emoji: '🌱'),
      (role: UserRole.volunteer, label: 'Demo Konselor', emoji: '👩‍⚕️'),
      (role: UserRole.admin, label: 'Demo Admin', emoji: '🛡️'),
    ];

    return Row(
      children: demoAccounts.map((demo) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: OutlinedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() => _selectedRole = demo.role);
                      _handleLogin();
                    },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Column(
                children: [
                  Text(demo.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 2),
                  Text(
                    demo.label,
                    style: const TextStyle(
                        fontSize: 10.5, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrivacyBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: AppColors.primaryDark, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privasi & Keamanan Data',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Semua data pemulihan Anda dienkripsi dan dijaga kerahasiaannya. '
                  'Anda dapat menggunakan nama samaran di forum dan konseling tanpa mengungkap identitas asli.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.primaryDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


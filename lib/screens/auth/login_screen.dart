import 'package:flutter/material.dart';
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

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'rian.pejuang@gmail.com');
  final _passwordController = TextEditingController(text: 'password123');
  UserRole _selectedRole = UserRole.korban;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    widget.appState.switchRole(_selectedRole);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigationScreen(appState: widget.appState),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masuk ke RuangPulih'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 10),
            const Text(
              'Selamat Datang Kembali',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Silakan masuk untuk melanjutkan jurnal dan sesi pemulihan Anda.',
              style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Role Selector Chips
            const Text(
              'Pilih Peran Akun (Role):',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: UserRole.values.map((r) {
                final isSelected = _selectedRole == r;
                return ChoiceChip(
                  label: Text(r.displayName),
                  selected: isSelected,
                  selectedColor: AppColors.primaryContainer,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedRole = r);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Email input
            const Text('Email Pengguna', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
                hintText: 'nama@email.com',
              ),
            ),
            const SizedBox(height: 16),

            // Password input
            const Text('Kata Sandi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                hintText: 'Masukkan kata sandi...',
              ),
            ),
            const SizedBox(height: 28),

            // Tombol Masuk
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Masuk ke Aplikasi'),
              ),
            ),
            const SizedBox(height: 16),

            // Akun Anonim Cepat
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.primaryDark, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Privasi Terjamin: Anda dapat menggunakan nama samaran di dalam forum dan konseling.',
                      style: TextStyle(fontSize: 11.5, color: AppColors.primaryDark),
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

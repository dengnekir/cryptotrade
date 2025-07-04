import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/register_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login_view.dart';
import '../../core/widgets/colors.dart';
import '../../core/utils/validators.dart';
import '../../profile/view/profile_view.dart';
import '../../core/view/main_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: const _RegisterViewContent(),
    );
  }
}

class _RegisterViewContent extends StatefulWidget {
  const _RegisterViewContent({Key? key}) : super(key: key);

  @override
  _RegisterViewContentState createState() => _RegisterViewContentState();
}

class _RegisterViewContentState extends State<_RegisterViewContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegisterViewModel>();
    final screenSize = MediaQuery.of(context).size;

    // ViewModeldeki hata mesajını local state'e yansıt
    if (viewModel.errorMessage != null &&
        viewModel.errorMessage != _errorMessage) {
      setState(() {
        _errorMessage = viewModel.errorMessage;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white, // Light mode background
      body: Stack(
        children: [
          // Geliştirilmiş Arkaplan Gradyanı
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.8,
                    colors: [
                      colorss
                          .getPrimaryGlowColor()
                          .withOpacity(_fadeAnimation.value * 0.1),
                      Colors.white, // Light mode gradient
                    ],
                    stops: [0.2, 0.8],
                  ),
                ),
              );
            },
          ),

          // Ana içerik
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: screenSize.height * 0.04),
                        _buildHeader(screenSize),
                        SizedBox(height: screenSize.height * 0.04),

                        // Hata mesajı
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: colorss.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorss.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: colorss.primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: colorss.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Adım Göstergesi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStepIndicator("Kişisel\nBilgiler",
                                isActive: viewModel.currentStep == 0),
                            Container(
                              width: screenSize.width * 0.3,
                              height: 2,
                              color: colorss.primaryColorDark.withOpacity(0.3),
                            ),
                            _buildStepIndicator("Şifre\nOluştur",
                                isActive: viewModel.currentStep == 1),
                          ],
                        ),

                        SizedBox(height: screenSize.height * 0.04),
                        _buildCurrentStepContent(viewModel),
                        SizedBox(height: screenSize.height * 0.04),
                        _buildNavigationButtons(viewModel),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()),
                            );
                          },
                          child: const Text(
                            'Hesabınız var mı? Giriş yap',
                            style: TextStyle(
                              color: colorss.backgroundColorDark,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (viewModel.isLoading)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorss.primaryColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(Size screenSize) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Crypto',
              style: TextStyle(
                color: Colors.black87,
                fontSize: screenSize.width / 10,
                fontWeight: FontWeight.normal,
                letterSpacing: -2,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            Text(
              '%',
              style: TextStyle(
                color: colorss.primaryColor,
                fontSize: screenSize.width / 10,
                fontWeight: FontWeight.bold,
                letterSpacing: -2,
                shadows: [
                  Shadow(
                    color: colorss.primaryColor.withOpacity(0.5),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            Text(
              'Trade',
              style: TextStyle(
                color: Colors.black87,
                fontSize: screenSize.width / 10,
                fontWeight: FontWeight.normal,
                letterSpacing: -2,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorss.primaryColor.withOpacity(0.1),
                blurRadius: 7,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            "Önce Güven",
            style: TextStyle(
              color: colorss.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: colorss.primaryColor.withOpacity(0.3),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator(String title, {required bool isActive}) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? colorss.primaryColorDark : colorss.backgroundColorLight,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? colorss.primaryColor : Colors.white,
            border: Border.all(
              color: colorss.primaryColor,
              width: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoStep(RegisterViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorss.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kişisel Bilgiler',
            style: TextStyle(
              color: colorss.backgroundColorLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              _buildInputField(
                controller: viewModel.nameController,
                label: 'Ad',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ad boş olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildInputField(
                controller: viewModel.surnameController,
                label: 'Soyad',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Soyad boş olamaz';
                  }
                  return null;
                },
              ),

            ],
          ),
          const SizedBox(height: 15),
          _buildInputField(
            controller: viewModel.emailController,
            label: 'E-posta',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStep(RegisterViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorss.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Şifre Oluştur',
            style: TextStyle(
              color: colorss.backgroundColorLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildInputField(
            controller: viewModel.passwordController,
            label: 'Şifre',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 15),
          _buildInputField(
            controller: viewModel.confirmPasswordController,
            label: 'Şifre Tekrar',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) {
              if (value != viewModel.passwordController.text) {
                return 'Şifreler eşleşmiyor';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final ValueNotifier<bool> _obscureText = ValueNotifier<bool>(isPassword);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorss.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: _obscureText,
        builder: (context, obscureTextValue, _) {
          return TextFormField(
            controller: controller,
            obscureText: obscureTextValue,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.black54),
              prefixIcon:
                  Icon(icon, color: colorss.backgroundColorDark.withOpacity(0.7)),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureTextValue
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: colorss.backgroundColorLight,
                      ),
                      onPressed: () {
                        _obscureText.value = !obscureTextValue;
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              errorStyle: const TextStyle(
                color: colorss.primaryColorLight,
              ),
            ),
            validator: validator,
          );
        },
      ),
    );
  }

  Widget _buildCurrentStepContent(RegisterViewModel viewModel) {
    if (viewModel.currentStep == 0) {
      return _buildPersonalInfoStep(viewModel);
    } else {
      return _buildPasswordStep(viewModel);
    }
  }

  Widget _buildProfileImagePicker(
      BuildContext context, RegisterViewModel viewModel) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorss.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showImageSourceDialog(context, viewModel),
        child: viewModel.profileImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(viewModel.profileImagePath!),
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    color: colorss.primaryColor.withOpacity(0.7),
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Profil Fotoğrafı\nEkle',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showImageSourceDialog(
      BuildContext context, RegisterViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.photo_camera, color: colorss.primaryColor),
              title:
                  const Text('Kamera', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                viewModel.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: colorss.primaryColor),
              title:
                  const Text('Galeri', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                viewModel.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(RegisterViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (viewModel.currentStep > 0)
          Expanded(
            child: ElevatedButton(
              onPressed: viewModel.previousStep,
              style: colorss.getPrimaryButtonStyle(),
              child: const Text(
                'Geri',
                style: TextStyle(
                  color: colorss.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (viewModel.currentStep > 0) const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                if (viewModel.currentStep == 0) {
                  viewModel.nextStep();
                  _animationController.forward(from: 0);
                } else {
                  try {
                    // Önceki hata mesajlarını temizle
                    setState(() {
                      _errorMessage = null;
                    });

                    final user = await viewModel.register();

                    // Kayıt başarılı mı kontrol et
                    if (user != null && mounted) {
                      // Önce başarılı bildirimini göster
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Kayıt başarılı! Ana sayfaya yönlendiriliyorsunuz...'),
                          backgroundColor: colorss.primaryColor,
                        ),
                      );

                      // Kısa bir gecikme ile kullanıcı ana sayfaya yönlendirilir
                      Future.delayed(const Duration(seconds: 1), () {
                        if (mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const MainView()),
                            (route) => false,
                          );
                        }
                      });
                    } else {
                      // Kullanıcı null ise veya başka bir sorun varsa
                      setState(() {
                        _errorMessage =
                            'Kayıt tamamlanamadı. Lütfen tekrar deneyin.';
                      });
                    }
                  } catch (e) {
                    setState(() {
                      _errorMessage = e.toString();
                    });
                  }
                }
              }
            },
            style: colorss.getPrimaryButtonStyle(),
            child: Text(
              viewModel.currentStep == 0 ? 'İleri' : 'Kayıt Ol',
              style: const TextStyle(
                color: colorss.textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

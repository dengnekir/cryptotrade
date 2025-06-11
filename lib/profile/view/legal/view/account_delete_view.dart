import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/profile_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../register/view/login_view.dart';
import '../../../../core/widgets/colors.dart';

class AccountDeleteView extends StatelessWidget {
  const AccountDeleteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const _AccountDeleteViewContent(),
    );
  }
}

class _AccountDeleteViewContent extends StatefulWidget {
  const _AccountDeleteViewContent({Key? key}) : super(key: key);

  @override
  State<_AccountDeleteViewContent> createState() => _AccountDeleteViewState();
}

class _AccountDeleteViewState extends State<_AccountDeleteViewContent> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _confirmDelete = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hesabı Sil',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: colorss.primaryColor,
                  size: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Hesabınızı Silmek Üzeresiniz',
                  style: TextStyle(
                    color: colorss.backgroundColorLight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bu işlem geri alınamaz. Hesabınız ve tüm verileriniz kalıcı olarak silinecektir.',
                  style: TextStyle(
                    color: colorss.backgroundColorDark,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  style: const TextStyle(color: Colors.black87),
                  decoration: colorss
                      .getTextFieldDecoration(
                        labelText: 'Şifrenizi Girin',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: colorss.backgroundColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      )
                      .copyWith(
                        labelStyle: const TextStyle(color: Colors.black54),
                        errorStyle: const TextStyle(
                          color: colorss.primaryColorLight,
                        ),
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CheckboxListTile(
                  value: _confirmDelete,
                  onChanged: (value) {
                    setState(() {
                      _confirmDelete = value ?? false;
                    });
                  },
                  title: const Text(
                    'Hesabımı kalıcı olarak silmek istediğimi onaylıyorum',
                    style: TextStyle(color: colorss.backgroundColorDark),
                  ),
                  checkColor: Colors.white,
                  activeColor: colorss.primaryColor,
                  side:
                      BorderSide(color: colorss.primaryColor.withOpacity(0.7)),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: colorss.getPrimaryButtonStyle().copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return colorss.primaryColor.withOpacity(0.3);
                          }
                          return colorss.primaryColor;
                        },
                      ),
                    ),
                    onPressed: !_confirmDelete
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text(
                                    'Son Onay',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: const Text(
                                    'Hesabınız kalıcı olarak silinecek. Bu işlem geri alınamaz. Devam etmek istediğinize emin misiniz?',
                                    style: TextStyle(
                                        color: colorss.backgroundColorDark),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('İptal',
                                          style: TextStyle(
                                              color:
                                                  colorss.backgroundColorDark)),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(
                                        'Hesabı Sil',
                                        style: TextStyle(
                                            color: colorss.primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (result == true && mounted) {
                                try {
                                  await viewModel.deleteAccount(
                                    password: _passwordController.text,
                                  );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Hesabınız başarıyla silindi.'),
                                        backgroundColor: colorss.primaryColor,
                                      ),
                                    );
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const LoginView(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Hata: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            }
                          },
                    child: Text(
                      'Hesabı Kalıcı Olarak Sil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            _confirmDelete ? colorss.textColor : Colors.white54,
                      ),
                    ),
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

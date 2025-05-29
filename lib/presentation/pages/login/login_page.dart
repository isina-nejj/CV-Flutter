import 'package:flutter/material.dart';
import '../../../core/style/colors.dart';
import '../../../core/style/text_styles.dart';
import '../../../core/style/sizes.dart';
import '../../../core/theme/dark_mode_controller.dart';
import '../../../shared/widgets/dark_mode_toggle.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  late final DarkModeController darkMode;

  @override
  void initState() {
    super.initState();
    darkMode = DarkModeController.shared;
    darkMode.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    darkMode.removeListener(_onThemeChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement login logic
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = darkMode.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ورود مدیر گروه',
          style: AppTextStyles.getPageTitle(darkMode.isDarkMode),
        ),
        backgroundColor: darkMode.isDarkMode
            ? AppColors.darkAppBarBackground
            : AppColors.appBarBackground,
        actions: [
          DarkModeToggle(controller: darkMode),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.darkLoginGradientStart,
                    AppColors.darkLoginGradientEnd
                  ]
                : [AppColors.loginGradientStart, AppColors.loginGradientEnd],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppSizes.pagePadding,
              child: Card(
                elevation: AppSizes.cardElevation,
                color: isDark ? AppColors.darkCardBackground : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppSizes.defaultRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'خوش آمدید',
                          style: AppTextStyles.getLoginTitle(isDark),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87),
                          decoration: InputDecoration(
                            labelText: 'ایمیل',
                            prefixIcon: Icon(Icons.email,
                                color: isDark ? Colors.white70 : null),
                            labelStyle: TextStyle(
                                color: isDark ? Colors.white70 : null),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark
                                    ? Colors.white30
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا ایمیل خود را وارد کنید';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'لطفا یک ایمیل معتبر وارد کنید';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87),
                          decoration: InputDecoration(
                            labelText: 'رمز عبور',
                            prefixIcon: Icon(Icons.lock,
                                color: isDark ? Colors.white70 : null),
                            labelStyle: TextStyle(
                                color: isDark ? Colors.white70 : null),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: isDark ? Colors.white70 : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark
                                    ? Colors.white30
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا رمز عبور خود را وارد کنید';
                            }
                            if (value.length < 6) {
                              return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? AppColors.darkLoginButtonBackground
                                  : AppColors.loginButtonBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppSizes.defaultRadius,
                              ),
                            ),
                            child: Text(
                              'ورود',
                              style: AppTextStyles.getLoginButtonText(isDark),
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
        ),
      ),
    );
  }
}

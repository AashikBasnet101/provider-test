import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/core/constants/app_color.dart';
import 'package:provider_test/core/constants/app_string.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/assignment/assignment.dart';
import 'package:provider_test/features/home/bottom_navbar.dart';
import 'package:provider_test/features/home/dashboard.dart';
import 'package:provider_test/features/home/dashboard1.dart';
import 'package:provider_test/features/provider/auth_provider.dart';
import 'package:provider_test/features/signup/signup.dart';

import 'package:provider_test/features/widgets/custom_elevatedbutton.dart';
import 'package:provider_test/features/widgets/custom_snackbar.dart';
import 'package:provider_test/features/widgets/custom_textformfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final authProvider = context.read<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: primaryColor,
          ),

          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width,
                  color: secondaryColor,

                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextform(
                            labelText: emailLabel,
                            keyboardType: TextInputType.emailAddress,
                            validator: authProvider.emailValidator,
                            onChanged: (p0) {
                              authProvider.email = p0;
                            },
                            prefixIcon: const Icon(Icons.email),
                          ),

                          CustomTextform(
                            labelText: passwordLabel,
                            validator: authProvider.passwordValidator,
                            onChanged: (p0) {
                              authProvider.password = p0;
                            },
                            obscureText: authProvider.isPasswordVisible,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                context.watch<AuthProvider>().isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                authProvider.togglePasswordVisibility();
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          CustomElevatedButton(
                            backgroundColor: primaryColor,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await authProvider.loginUser();

                                if (authProvider.loginStatus ==
                                    ViewState.success) {
                                  displaySnackBar(context, loginSuccess);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavbar(),
                                    ),
                                  );
                                } else if (authProvider.loginStatus ==
                                    ViewState.error) {
                                  displaySnackBar(context, loginfailed);
                                }
                              }
                            },
                            child: authProvider.loginStatus == ViewState.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(loginLabel),
                          ),

                          SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Signup(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: primaryColor,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

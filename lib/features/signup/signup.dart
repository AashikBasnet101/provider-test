import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/core/constants/app_color.dart';
import 'package:provider_test/core/constants/app_string.dart';
import 'package:provider_test/core/utils/helper.dart';
import 'package:provider_test/core/utils/view_state.dart';
import 'package:provider_test/features/login/login.dart';
import 'package:provider_test/features/provider/auth_provider.dart';
import 'package:provider_test/features/widgets/custom_dropdown.dart';
import 'package:provider_test/features/widgets/custom_elevatedbutton.dart';
import 'package:provider_test/features/widgets/custom_snackbar.dart';
import 'package:provider_test/features/widgets/custom_textformfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: primaryColor,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
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
                        prefixIcon: const Icon(Icons.email),
                        onChanged: (p0) {
                          authProvider.email = p0;
                        },
                      ),

                      CustomTextform(
                        labelText: userLabel,
                        validator: authProvider.userValidator,
                        prefixIcon: const Icon(Icons.person),
                        onChanged: (p0) {
                          authProvider.username = p0;
                        },
                      ),

                      CustomTextform(
                        labelText: nameLabel,
                        validator: authProvider.nameValidator,
                        prefixIcon: const Icon(Icons.badge),
                        onChanged: (p0) {
                          authProvider.fullName = p0;
                        },
                      ),

                      CustomTextform(
                        labelText: contactLabel,
                        keyboardType: TextInputType.phone,
                        validator: authProvider.contactValidator,
                        prefixIcon: const Icon(Icons.phone),
                        onChanged: (p0) {
                          authProvider.contact = p0;
                        },
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
                            authProvider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            authProvider.togglePasswordVisibility();
                          },
                        ),
                      ),

                      DropDown(
                        labelText: genderLabel,
                        items: genderOptions,
                        value: context.watch<AuthProvider>().gender,
                        onChanged: (val) {
                          authProvider.setGender(val);
                        },
                        validator: authProvider.genderValidator,
                      ),

                      DropDown(
                        labelText: roleLabel,
                        items: roleOptions,
                        value: authProvider.role,
                        onChanged: (val) {
                          authProvider.setRole(val);
                        },
                        validator: authProvider.roleValidator,
                      ),

                      const SizedBox(height: 20),
                      CustomElevatedButton(
                        backgroundColor: primaryColor,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await authProvider.signupUser();

                            if (authProvider.signupStatus ==
                                ViewState.success) {
                              displaySnackBar(context, registerSuccess);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            } else if (authProvider.signupStatus ==
                                ViewState.error) {
                              displaySnackBar(context, registerfailed);
                            }
                          }
                        },
                        child: Text(signupLabel),
                      ),

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: Text(
                              loginLabel,
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
          ),
          authProvider.signupStatus == ViewState.loading
              ? backdropFilter(context)
              : SizedBox(),
        ],
      ),
    );
  }
}

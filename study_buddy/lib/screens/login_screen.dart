import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  // ================= CONTROLLER =================
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  bool _isLoading = false;

  // ================= LOGIN =================
  Future<void> login() async {

    if (!_formKey.currentState!
        .validate()) {

      return;
    }

    setState(() {

      _isLoading = true;
    });

    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(

        email:
            emailController.text
                .trim(),

        password:
            passwordController.text
                .trim(),
      );

    } on FirebaseAuthException catch (e) {

      String message =
          'Login gagal';

      if (e.code ==
          'user-not-found') {

        message =
            'User tidak ditemukan';
      }

      else if (e.code ==
          'wrong-password') {

        message =
            'Password salah';
      }

      else if (e.code ==
          'invalid-email') {

        message =
            'Email tidak valid';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(message),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            'Error: $e',
          ),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {

          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            padding:
                const EdgeInsets.all(
              24,
            ),

            child: Form(

              key: _formKey,

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                children: [

                  // ================= LOGO =================
                  const Icon(

                    Icons.school,

                    size: 90,

                    color: Colors.blue,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ================= TITLE =================
                  const Text(

                    'Study Buddy',

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(

                      fontSize: 32,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(

                    'Belajar bersama jadi lebih mudah',

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  // ================= EMAIL =================
                  TextFormField(

                    controller:
                        emailController,

                    keyboardType:
                        TextInputType.emailAddress,

                    decoration:
                        const InputDecoration(

                      labelText:
                          'Email',

                      prefixIcon:
                          Icon(Icons.email),
                    ),

                    validator: (
                      value,
                    ) {

                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {

                        return 'Email wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ================= PASSWORD =================
                  TextFormField(

                    controller:
                        passwordController,

                    obscureText: true,

                    decoration:
                        const InputDecoration(

                      labelText:
                          'Password',

                      prefixIcon:
                          Icon(Icons.lock),
                    ),

                    validator: (
                      value,
                    ) {

                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {

                        return 'Password wajib diisi';
                      }

                      if (value.length < 6) {

                        return 'Minimal 6 karakter';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // ================= LOGIN BUTTON =================
                  ElevatedButton(

                    onPressed:
                        _isLoading
                            ? null
                            : login,

                    child:
                        _isLoading

                            ? const SizedBox(

                                height: 22,

                                width: 22,

                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                ),
                              )

                            : const Text(
                                'Login',
                              ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ================= REGISTER =================
                  Row(

                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      const Text(
                        'Belum punya akun?',
                      ),

                      TextButton(

                        onPressed: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  const RegisterScreen(),
                            ),
                          );
                        },

                        child: const Text(
                          'Register',
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
    );
  }
}
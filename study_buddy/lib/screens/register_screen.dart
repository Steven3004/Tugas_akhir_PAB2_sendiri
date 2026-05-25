import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  // ================= CONTROLLER =================
  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  bool _isLoading = false;

  // ================= REGISTER =================
  Future<void> register() async {

    if (!_formKey.currentState!
        .validate()) {

      return;
    }

    if (passwordController.text
            .trim() !=
        confirmPasswordController.text
            .trim()) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            'Konfirmasi password tidak cocok',
          ),
        ),
      );

      return;
    }

    setState(() {

      _isLoading = true;
    });

    try {

      // CREATE USER
      final credential =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(

        email:
            emailController.text
                .trim(),

        password:
            passwordController.text
                .trim(),
      );

      // UPDATE PROFILE
      await credential.user
          ?.updateDisplayName(

        nameController.text.trim(),
      );

      await credential.user
          ?.reload();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            'Register berhasil',
          ),
        ),
      );

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      String message =
          'Register gagal';

      if (e.code ==
          'email-already-in-use') {

        message =
            'Email sudah digunakan';
      }

      else if (e.code ==
          'weak-password') {

        message =
            'Password terlalu lemah';
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

    nameController.dispose();

    emailController.dispose();

    passwordController.dispose();

    confirmPasswordController
        .dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Register',
        ),
      ),

      body: SafeArea(

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

                const SizedBox(
                  height: 20,
                ),

                // ================= ICON =================
                const Icon(

                  Icons.person_add,

                  size: 90,

                  color: Colors.blue,
                ),

                const SizedBox(
                  height: 24,
                ),

                // ================= TITLE =================
                const Text(

                  'Create Account',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(

                    fontSize: 28,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(

                  'Daftar untuk mulai belajar bersama',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                // ================= NAME =================
                TextFormField(

                  controller:
                      nameController,

                  decoration:
                      const InputDecoration(

                    labelText:
                        'Nama Lengkap',

                    prefixIcon:
                        Icon(Icons.person),
                  ),

                  validator: (
                    value,
                  ) {

                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {

                      return 'Nama wajib diisi';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 18,
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
                  height: 18,
                ),

                // ================= CONFIRM PASSWORD =================
                TextFormField(

                  controller:
                      confirmPasswordController,

                  obscureText: true,

                  decoration:
                      const InputDecoration(

                    labelText:
                        'Konfirmasi Password',

                    prefixIcon:
                        Icon(Icons.lock_outline),
                  ),

                  validator: (
                    value,
                  ) {

                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {

                      return 'Konfirmasi password wajib diisi';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 30,
                ),

                // ================= BUTTON =================
                ElevatedButton(

                  onPressed:
                      _isLoading
                          ? null
                          : register,

                  child:
                      _isLoading

                          ? const SizedBox(

                              width: 22,
                              height: 22,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                              ),
                            )

                          : const Text(
                              'Register',
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/provider/auth_provider.dart';
import 'package:riverpod_ecommerce/utils/app_toast.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    // confirmpasswordController.dispose();
    // usernameController.dispose();
    // phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<String>>(authProvider, (prev, next) {
      if (prev != next) {
        next.whenOrNull(
          data: (message) {
            if (message.isNotEmpty) {
              //  CompanyToast.show(context, message, type: ToastType.success);
              AppToast.show(
                context,
                message,
                type: ToastTypes.success,
                position: ToastPosition.bottom,
                duration: Duration(seconds: 5),
              );
              Future.microtask(() {
                if (!context.mounted) return;
                ref.read(authProvider.notifier).reset();

                Navigator.pushReplacementNamed(
                  context,
                  '/',
                  //arguments: {'email': emailController.text},
                );
              });
            }
          },
          error: (e, _) {
            if (kDebugMode) {
              print('error');
            }
          },
        );
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                style: TextStyle(fontSize: 15),
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Name is required'
                            : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                style: TextStyle(fontSize: 15),
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              // TextFormField(
              //   style: TextStyle(fontSize: 15),
              //   controller: usernameController,
              //   decoration: const InputDecoration(labelText: 'Username'),
              //   validator: (value) {
              //     if (value == null || value.trim().isEmpty) {
              //       return 'Username is required';
              //     }

              //     return null;
              //   },
              // ),
              // TextFormField(
              //   style: TextStyle(fontSize: 15),
              //   controller: phoneController,
              //   decoration: const InputDecoration(labelText: 'Phone Number'),
              //   validator: (value) {
              //     if (value == null || value.trim().isEmpty) {
              //       return 'Phone Number is required';
              //     }

              //     return null;
              //   },
              // ),
              TextFormField(
                style: TextStyle(fontSize: 15),
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      size: 20,
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // TextFormField(
              //   style: TextStyle(fontSize: 15),
              //   controller: confirmpasswordController,
              //   obscureText: true,
              //   decoration: InputDecoration(
              //     labelText: 'Confirm Password',
              //     suffixIcon: IconButton(
              //       icon: Icon(
              //         size: 20,
              //         _obscureConfirm ? Icons.visibility_off : Icons.visibility,
              //       ),
              //       onPressed: () {
              //         setState(() => _obscureConfirm = !_obscureConfirm);
              //       },
              //     ),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Confirm Password is required';
              //     }
              //     if (value != passwordController.text) {
              //       return 'Passwords do not match';
              //     }
              //     if (value.length < 6) {
              //       return 'Confirm Password must be at least 6 characters';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed:
                    ref.watch(authProvider).isLoading
                        ? null
                        : () {
                          if (_formKey.currentState!.validate()) {
                            // Perform signup logic
                            ref
                                .read(authProvider.notifier)
                                .register(
                                  emailController.text,

                                  // confirmpasswordController.text,
                                  // usernameController.text,
                                  nameController.text,
                                  passwordController.text,
                                  // phoneController.text,
                                );
                          }
                        },
                child:
                    ref.watch(authProvider).isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                        : const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/'),
                child: const Text(
                  "Do you have an account? Login",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

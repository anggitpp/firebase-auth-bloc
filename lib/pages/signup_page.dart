import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

import '../blocs/signup/signup_cubit.dart';
import '../utils/error_dialog.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/signup';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _name, _email, _password;
  final _passwordController = TextEditingController();

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    context
        .read<SignupCubit>()
        .signUp(name: _name!, email: _email!, password: _password!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<SignupCubit, SignUpState>(
        listener: (context, state) {
          if (state.signUpStatus == SignUpStatus.error) {
            errorDialog(context, state.error);
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Image.asset(
                        'assets/images/flutter_logo.png',
                        width: 250,
                        height: 250,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.account_box),
                        ),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name required';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _name = value;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email required';
                          }
                          if (!isEmail(value.trim())) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _email = value;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password required';
                          }
                          if (value.trim().length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _password = value;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (String? value) {
                          if (_passwordController.text != value) {
                            return 'Password not match';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _password = value;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: state.signUpStatus == SignUpStatus.submitting
                            ? null
                            : _submit,
                        child: Text(
                            state.signUpStatus == SignUpStatus.submitting
                                ? 'Loading'
                                : 'Sign Up'),
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: state.signUpStatus == SignUpStatus.submitting
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        child: const Text('Already a member? Sign in!'),
                        style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

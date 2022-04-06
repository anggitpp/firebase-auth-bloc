import 'package:fb_auth_bloc/blocs/signin/signin_cubit.dart';
import 'package:fb_auth_bloc/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/error_dialog.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/signin';

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    print('email: $_email, password: $_password');

    context.read<SigninCubit>().signIn(email: _email!, password: _password!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<SigninCubit, SignInState>(
        listener: (context, state) {
          if (state.signInStatus == SignInStatus.error) {
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
                      ElevatedButton(
                        onPressed: state.signInStatus == SignInStatus.submitting
                            ? null
                            : _submit,
                        child: Text(
                            state.signInStatus == SignInStatus.submitting
                                ? 'Loading'
                                : 'Sign In'),
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
                        onPressed: state.signInStatus == SignInStatus.submitting
                            ? null
                            : () => Navigator.pushNamed(
                                context, SignUpPage.routeName),
                        child: const Text('Not a member? Sign Up!'),
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

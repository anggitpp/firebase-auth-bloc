import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/signin';

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('SignIn')),
    );
  }
}

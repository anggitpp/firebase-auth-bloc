import 'package:fb_auth_bloc/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Home'),
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ProfilePage();
              })),
              icon: const Icon(Icons.account_circle),
            ),
            IconButton(
              onPressed: () =>
                  context.read<AuthBloc>().add(SignOutRequestedEvent()),
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bloc_logo_full.png',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
                'Bloc is an awesome\nstate management library\nfor flutter!'),
          ],
        )),
      ),
    );
  }
}

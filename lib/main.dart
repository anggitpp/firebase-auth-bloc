import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_auth_bloc/blocs/signin/signin_cubit.dart';
import 'package:fb_auth_bloc/pages/signup_page.dart';
import 'package:fb_auth_bloc/pages/splash_page.dart';
import 'package:fb_auth_bloc/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/signup/signup_cubit.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/home_page.dart';
import 'pages/signin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: FirebaseAuth.instance),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SigninCubit>(
            create: (context) => SigninCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Firebase Auth',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashPage(),
          routes: {
            SignUpPage.routeName: (context) => const SignUpPage(),
            SignInPage.routeName: (context) => const SignInPage(),
            HomePage.routeName: (context) => const HomePage(),
          },
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foto_share/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login/bloc/auth_bloc.dart';
import 'login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (context) => AuthBloc()..add(VerifyAuthEvent()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Intente autenticarse..."),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthSuccessState) {
          return HomePage();
        } else if (state is AuthErrorState) {
          return LoginPage();
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }
}

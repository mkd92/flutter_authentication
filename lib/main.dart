import 'package:authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:authentication/logic/simple_bloc_observer.dart';
import 'package:authentication/pages/home_screen.dart';
import 'package:authentication/pages/login_screen.dart';
import 'package:authentication/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // Bloc.observer = SimpleBlocObserver()
  final UserRepository userRepository = UserRepository();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        print(snapshot.hasError);
        if (snapshot.hasError != null) {
          return MyApp();
        } else {
          return BlocProvider(
            create: (context) =>
            AuthenticationBloc(userRepository: userRepository)
              ..add(
                AuthenticationStarted(),
              ),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationFailure) {
                    return LoginScreen();
                  } else if (state is AuthenticationSuccess) {
                    return HomeScreen();
                  } else {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text("loading"),
                      ),
                    );
                  }
                },
              ),
            ),
          );;
        }
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("error"),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pet_app/src/providers/provider.dart';
import 'package:pet_app/src/screens/confirm_register.dart';
import 'package:pet_app/src/screens/forgot_password.dart';
import 'package:pet_app/src/screens/home_screen.dart';
import 'package:pet_app/src/screens/login_screen.dart';
import 'package:pet_app/src/screens/signup_screen.dart';
import 'package:pet_app/src/services/auth_service.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: "pet authentification",
        home: FutureBuilder(
          future: AuthService.getToken(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
        initialRoute: '/login',
        routes: {
          '/home': (_) => HomeScreen(),
          '/login': (_) => new LoginScreen(),
          '/signup': (_) => new SignupScreen(),
          '/forgot_password': (_) => new ForgotPassword(),
          '/confirm_register': (_) => new ConfirmRegister(),
        },
      ),
    );
  }
}

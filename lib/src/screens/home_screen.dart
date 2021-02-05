import 'package:flutter/material.dart';
import 'package:pet_app/src/services/auth_service.dart';
// import 'package:login_statefull/src/chat/ChatUsersScreen.dart';

class HomeScreen extends StatelessWidget {
  // render
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 400),
          child: Column(
            children: [
              Text('Home Screen'),
              RaisedButton(
                child: Text('Log out'),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/login');
                  AuthService.removeToken();
                },
              ),
              // RaisedButton(
              //   child: Text("go chat"),
              //   onPressed: () async {
              //     await Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => ChatUsersScreen()),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

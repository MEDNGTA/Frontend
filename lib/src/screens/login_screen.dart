import 'package:flutter/material.dart';
import 'package:pet_app/src/mixins/helper.dart';
import 'dart:io';

import '../blocs/form_bloc.dart';
import '../providers/provider.dart';

class LoginScreen extends StatelessWidget {
  // single approch way
  // final bloc = new FormBloc();
  static const String ROUTE_ID = 'login_screen';

  @override
  Widget build(BuildContext context) {
    final FormBloc formBloc = Provider.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          margin: Platform.isIOS
              ? EdgeInsets.only(top: 400.0, left: 50.0, right: 50.0)
              : EdgeInsets.only(top: 250.0, left: 50.0, right: 50.0),
          height: Platform.isIOS ? 550.0 : 600.0,
          child: Form(
            child: Column(
              children: <Widget>[
                _emailField(formBloc),
                _passwordField(formBloc),
                Container(
                  width: 300,
                  height: 35,
                  child: Helper().errorMessage(formBloc),
                ),
                _checkBox(),
                _buttonField(formBloc),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/forgot_password'),
                      child: Container(
                        child: Text('Forgot password?'),
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/signup'),
                      child: Container(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField(FormBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.email,
        builder: (context, snapshot) {
          return TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'you@example.com',
              labelText: 'Email',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEmail,
          );
        });
  }

  Widget _passwordField(FormBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.password,
        builder: (context, snapshot) {
          return TextField(
            obscureText: true,
            onChanged: bloc.changePassword,
            maxLength: 20,
            decoration: InputDecoration(
              hintText: '',
              labelText: 'Password',
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _checkBox() {
    return Row(
      children: <Widget>[
        Checkbox(
          onChanged: (checked) => {},
          value: false,
        ),
        Text('keep me logged in'),
      ],
    );
  }

  Widget _buttonField(FormBloc bloc) {
    return StreamBuilder<bool>(
        stream: bloc.submitLoginForm,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              onPressed: () async {
                print(snapshot);
                if (snapshot.hasError) {
                  //print(snapshot.error);
                  return null;
                }
                await bloc.login(context);
              },
              // child: const Icon(Icons.arrow_forward),
              child: Text(
                'SIGN-IN',
                style: TextStyle(
                    fontSize: 20, color: Colors.white, letterSpacing: 2.0),
              ),
              color: Colors.deepOrangeAccent,
              clipBehavior: Clip.hardEdge,
              elevation: 10,
              disabledColor: Colors.blueGrey,
              disabledElevation: 10,
              disabledTextColor: Colors.white,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          );
        });
  }
}

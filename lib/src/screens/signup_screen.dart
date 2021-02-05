import 'package:flutter/material.dart';
import 'package:pet_app/src/mixins/helper.dart';
import '../local/data.dart';
import '../blocs/form_bloc.dart';
import '../providers/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupScreen extends StatefulWidget {
  // single approch way
  // final bloc = new FormBloc();

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  DatabaseHelper db;
  final phoneNC = TextEditingController();
  // @override
  // void initState() {
  //   super.initState();
  //   db = DatabaseHelper.dbHelper;
  // }

  @override
  Widget build(BuildContext context) {
    final FormBloc formBloc = Provider.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
          height: 600.0,
          child: Form(
            child: Column(
              children: <Widget>[
                _emailField(formBloc),
                _passwordField(formBloc),
                _usernameField(formBloc),
                _fNameField(formBloc),
                _lNameField(formBloc),
                Container(
                  width: 10,
                  height: 10,
                  child: Center(),
                ),
                _phoneField(formBloc),
                Container(
                  width: 10,
                  height: 25,
                  child: Helper().errorMessage(formBloc),
                ),
                //_checkBox(),
                _buttonField(formBloc),
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

  Widget _usernameField(FormBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.username,
        builder: (context, snapshot) {
          return TextField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'Horse',
              labelText: 'Username',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeUsername,
          );
        });
  }

  Widget _fNameField(FormBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.first,
        builder: (context, snapshot) {
          return TextField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'John',
              labelText: 'First Name',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeFirst,
          );
        });
  }

  Widget _lNameField(FormBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.last,
        builder: (context, snapshot) {
          return TextField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'Doe',
              labelText: 'Last Name',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeLast,
          );
        });
  }

  Widget _phoneField(FormBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.phone,
        builder: (context, snapshot) {
          return IntlPhoneField(
            controller: phoneNC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '0770744588',
              labelText: 'Phone Number',
              errorText: snapshot.error,
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            initialCountryCode: 'DZ',
            onChanged: bloc.changePhone,
          );
        });
  }

  Widget _buttonField(FormBloc bloc) {
    return StreamBuilder<bool>(
        stream: bloc.submitValidForm,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              onPressed: () async {
                if (snapshot.hasError) {
                  return null;
                }
                debugPrint(phoneNC.text);
                int res = await bloc.register(context);

                debugPrint("status code = ${res}");
                //bloc.dispose();
              },
              //child: const Icon(Icons.arrow_forward),
              child: Text(
                'SIGN-UP',
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

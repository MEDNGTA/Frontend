import 'package:flutter/material.dart';
import 'package:pet_app/src/screens/login_screen.dart';
import '../blocs/form_bloc.dart';
import '../providers/provider.dart';
import 'package:pet_app/src/mixins/helper.dart';

class ForgotPassword extends StatelessWidget {
  final myController = TextEditingController();
// render
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
          margin: EdgeInsets.only(top: 300.0, left: 50.0, right: 50.0),
          height: 550.0,
          child: Form(
            child: Column(
              children: <Widget>[
                _emailField(formBloc),
                Container(
                  width: 300,
                  height: 35,
                  child: Helper().errorMessage(formBloc),
                ),
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
            controller: myController,
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

  Widget _buttonField(FormBloc bloc) {
    //email account
    return StreamBuilder<bool>(
        stream: bloc.submitForEmForm,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              onPressed: () async {
                // confirm email
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return null;
                }
                //code here
                try {
                  dynamic res =
                      await bloc.confirmForg(context, myController.text);
                  print("pppp =>${res["code"]}");
                  print("result = $res");
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotCode(
                                code: res["code"],
                                email: myController.text,
                              )));
                } on Error catch (e) {
                  print(e);
                }
              },
              // child: const Icon(Icons.arrow_forward),
              child: Text(
                'Confirm email',
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

class ForgotCode extends StatelessWidget {
// render
  final int code;
  final String email;
  ForgotCode({Key key, @required this.code, @required this.email})
      : super(key: key);
  final myCode = TextEditingController();
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
          margin: EdgeInsets.only(top: 300.0, left: 50.0, right: 50.0),
          height: 550.0,
          child: Form(
            child: Column(
              children: <Widget>[
                _codeField(formBloc),
                Container(
                  width: 300,
                  height: 35,
                  child: Helper().errorMessage(formBloc),
                ),
                _buttonField(formBloc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _codeField(FormBloc bloc) {
    //code
    return StreamBuilder<String>(
        stream: bloc.code,
        builder: (context, snapshot) {
          return TextField(
            controller: myCode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '000000',
              labelText: 'Confirmation Code',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeCode,
          );
        });
  }

  Widget _buttonField(FormBloc bloc) {
    return StreamBuilder<bool>(
        stream: bloc.submitForCoForm,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              onPressed: () async {
                //confirm code
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return null;
                }
                //code here
                if (int.parse(myCode.text) == code) {
                  print(email);

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotConfirm(
                              email: email,
                            )),
                  );
                }
              },
              // child: const Icon(Icons.arrow_forward),
              child: Text(
                'Confirm code',
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

class ForgotConfirm extends StatelessWidget {
  final String email;
  ForgotConfirm({Key key, @required this.email}) : super(key: key);
  final firstPass = TextEditingController();
  final secondPass = TextEditingController();
// render
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
          margin: EdgeInsets.only(top: 300.0, left: 50.0, right: 50.0),
          height: 550.0,
          child: Form(
            child: Column(
              children: <Widget>[
                _passwordField(formBloc, "Password", firstPass),
                _passwordField(formBloc, "Re-Password", secondPass),
                Container(
                  width: 300,
                  height: 35,
                  child: Helper().errorMessage(formBloc),
                ),
                _buttonField(formBloc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField(
      FormBloc bloc, String lableName, TextEditingController myController) {
    //finish the procedure forgot password
    return StreamBuilder<String>(
        stream: bloc.password,
        builder: (context, snapshot) {
          return TextField(
            controller: myController,
            obscureText: true,
            onChanged: bloc.changePassword,
            maxLength: 20,
            decoration: InputDecoration(
              hintText: '',
              labelText: lableName,
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _buttonField(FormBloc bloc) {
    return StreamBuilder<bool>(
        stream: bloc.submitForPaForm,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              onPressed: () async {
                //confirm password
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return null;
                }
                //code here
                if (firstPass.text == secondPass.text) {
                  await bloc.confirmPass(context, email, firstPass.text);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  bloc.addError("problem in password, please retry");
                }
              },
              // child: const Icon(Icons.arrow_forward),
              child: Text(
                'Confirm password',
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

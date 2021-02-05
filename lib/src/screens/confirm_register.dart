import 'package:flutter/material.dart';
import 'package:pet_app/src/mixins/helper.dart';
import 'package:pet_app/src/screens/login_screen.dart';
import '../local/data.dart';
import '../blocs/form_bloc.dart';
import '../providers/provider.dart';
import '../local/dbHelper.dart';

class ConfirmRegister extends StatelessWidget {
  // single approch way
  // final bloc = new FormBloc();
  DatabaseHelper db;
  final myController = TextEditingController();
  String cEmail;
  int cCode;
  ConfirmRegister({Key key, this.cEmail, this.cCode}) : super(key: key);
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
    return StreamBuilder<String>(
        stream: bloc.code,
        builder: (context, snapshot) {
          return TextField(
            controller: myController,
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
        stream: bloc.submitValidForm,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              onPressed: () async {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return null;
                }
                try {
                  int code = int.parse(myController.text);
                  if (cCode == code) {
                    await bloc.confirm(context, cEmail);
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  } else {
                    bloc.addError("code incorrect");
                  }
                } on Error catch (e) {
                  print(e);
                }
              },
              // child: const Icon(Icons.arrow_forward),
              child: Text(
                'Confirm',
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

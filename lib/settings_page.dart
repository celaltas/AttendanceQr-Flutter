import 'package:attendanceviaqr/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'services/auth_services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switchState = false;
  var formKeyEmail = GlobalKey<FormState>();
  String _newEmail;
  var formKeyPassword = GlobalKey<FormState>();
  String _newPassword;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Container(
      child: ListView(
        children: ListTile.divideTiles(
          context: context,
          color: Colors.black,
          tiles: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text("Font Size"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  title: Text("Change Email"),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  onTap: () {
                    mailDialog(context, auth);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  title: Text("Change Password"),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  onTap: () {
                    passwordDialog(context, auth);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SwitchListTile(
                title: Text("Dark Mode"),
                value: switchState,
                onChanged: (value) {
                  setState(() {
                    switchState = value;
                    BlocProvider.of<ThemeBloc>(context)
                        .add(ChangeThemeEvent(switchState: switchState));
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(title: Text("Privacy Policy")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(title: Text("User Agreement")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(title: Text("Terms of Use")),
            ),
          ],
        ).toList(),
      ),
    );
  }

  void passwordDialog(BuildContext context, AuthService auth) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Change Password",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKeyPassword,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "New Password",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _newPassword = value;
                    },
                    validator: (value) {
                      if (value.length < 6) {
                        return "At least six characters";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (formKeyPassword.currentState.validate()) {
                        formKeyPassword.currentState.save();
                        await auth.resetPassword(_newPassword);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Change"),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ],
                alignment: MainAxisAlignment.center,
              )
            ],
          );
        });
  }

  void mailDialog(BuildContext context, AuthService auth) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Change Email",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKeyEmail,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "New Email",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _newEmail = value;
                    },
                    validator: (value) {
                      if (value.length < 6) {
                        return "At least six characters";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (formKeyEmail.currentState.validate()) {
                        formKeyEmail.currentState.save();
                        await auth.resetEmail(_newEmail);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Change"),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ],
                alignment: MainAxisAlignment.center,
              )
            ],
          );
        });
  }
}

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switchState =false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
       children:  ListTile.divideTiles(context: context,color: Colors.black,
         tiles: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ListTile(title: Text("Font Size"),trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),),
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ListTile(title: Text("Change Email"),trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),),
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ListTile(title: Text("Change Password"),trailing: Icon(Icons.arrow_forward_ios, color: Colors.black,),),
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: SwitchListTile(title: Text("Dark Mode"), value: switchState, onChanged: (value){
               setState(() {
                 switchState=value;
               });
             },),
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
}
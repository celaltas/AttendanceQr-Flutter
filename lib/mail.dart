import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:file_picker/file_picker.dart';


class MailPage extends StatefulWidget {



  @override
  _MailPageState createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {

  String _attachmentPath;
  final _toController = TextEditingController(text: 'example@example.com');
  final _subjectController = TextEditingController(text: 'The subject');
  final _bodyController = TextEditingController(text: 'Mail body.');
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Mail"),
        actions: [
          IconButton( icon: Icon(Icons.send), onPressed:_send)
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _toController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'To',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Subject',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _bodyController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          labelText: 'Body', border: OutlineInputBorder()),
                    ),
                  ),
                ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera),
        label: Text('Add File'),
        onPressed: _openFileExplorer,
      ),
    );
  }

  Future<void> _openFileExplorer() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result != null) {
      File file = File(result.files.single.path);
      setState(() {
        _attachmentPath = file.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Attachment added."),));
    } else {
      debugPrint("Don't selected");
    }
  }

  Future<void> _send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_toController.text],
      attachmentPaths: [_attachmentPath],

    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
      print(platformResponse);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }
}

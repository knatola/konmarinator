import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trailer_lender/src/models/item.dart';
import 'package:trailer_lender/src/models/note.dart';

import '../../util.dart';

class AddNoteView extends StatefulWidget {

  AddNoteView(this.item) {
    print('constructor called with: $item');
  }

  final Item item;
  @override
  State<StatefulWidget> createState() {
    return AddNoteState(item);
  }
}

class AddNoteState extends State<AddNoteView> {
  final formKey = GlobalKey<FormState>();
  String noteText;
  Item item;

  AddNoteState(this.item);

  Widget _buildTextField() {
    return TextFormField(
      maxLines: 20,
      minLines: 10,
      keyboardType: TextInputType.text,
      obscureText: false,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
      decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(32.0)),
          hintText: "Note",
          icon: new Icon(
            Icons.format_quote,
            color: Theme.of(context).primaryColor,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0))),
//          validator: (value) => value.isEmpty ? 'Tags can\'t be empty' : null,
      onSaved: (value) => noteText = value,
    );
  }

  Widget _buildForm() {
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(context),
      ),
      child: Form(
          key: formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: ListView(
                reverse: true,
//          shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildTextField(),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }
  
  void _createNote() {
    if (validateAndSave()) {
      if (noteText != null && noteText != "") {
        final date = DateTime.now();
        final text = noteText;
        final itemId = item.id;
        final id = Random().nextInt(1000);
        Note newNote = Note(date: date, text: text, itemId: itemId, id: id);
        Navigator.pop(context, newNote);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNote();
        },
        child: Icon(Icons.done),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text("Note"),
        actions: <Widget>[],
      ),
      body: _buildForm(),
    );
  }
}

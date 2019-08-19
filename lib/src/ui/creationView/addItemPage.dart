import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trailer_lender/src/bloc/itemBloc.dart';
import 'package:trailer_lender/src/models/image.dart';
import 'package:trailer_lender/src/models/item.dart';
import 'package:trailer_lender/src/service/logger.dart';

import '../../util.dart';
import 'add-image-screen.dart';

class AddItemPage extends StatefulWidget {
  final log = getLogger('AddItemPage');

  @override
  State<StatefulWidget> createState() {
    return AddItemState();
  }
}

class AddItemState extends State<AddItemPage> {
  ItemBloc _itemBloc;
  BuildContext scaffoldCtx;
  final formKey = new GlobalKey<FormState>();
  final rng = Random();
  final TextStyle fieldStyle =
      new TextStyle(color: Colors.white, fontWeight: FontWeight.normal);

  String newName = "";
  List<ItemImage> images;
  List<String> tags;
  String errorMessage;
  DateTime currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _itemBloc = ItemBlocProvider.of(context);
  }

  @override
  void initState() {
    errorMessage = "";
    tags = [];
    images = [];
    super.initState();
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  Widget _buildImageList() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
          height: 300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: images.length,
              padding: const EdgeInsets.all(4.0),
              itemBuilder: (context, position) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  color: Colors.transparent,
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: getGradient(
                          context,
                        )),
                    height: 260,
                    width: 280,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            height: 230,
                            width: 260,
                            child: Image.network(images[position].imageUrl,
                                fit: BoxFit.fitWidth),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: Text(
                            images[position].imageName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })),
    );
  }

  Widget _buildImageButton() {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).primaryColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
              ItemImage newImg = await Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => AddImageScreen()));
              if (newImg != null) images.add(newImg);
            },
            child: Text("Add image",
                textAlign: TextAlign.center,
                style: new TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ));
  }

  Widget _buildNameField() {
    return Padding(
        padding: EdgeInsets.only(right: 16, left: 16),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          obscureText: false,
          style: fieldStyle,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Name",
              hintStyle: TextStyle(
                  color: Colors.grey
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              prefixIcon: new Icon(
                Icons.title,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(32.0))),
          validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
          onSaved: (value) => newName = value,
        ));
  }

  Widget _buildTagField() {
    return Padding(
        padding: EdgeInsets.only(top: 16, right: 16, left: 16),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          obscureText: false,
          style: fieldStyle,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Tags",
              hintStyle: TextStyle(
                  color: Colors.grey
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(color: Colors.white),
              ),
              prefixIcon: new Icon(
                Icons.attach_file,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(32.0))),
          validator: (value) => value.isEmpty ? 'Tags can\'t be empty' : null,
          onSaved: (value) => newName = value,
        ));
  }

  Widget _buildForm() {
    return Center(
        child: Container(
            child: Form(
                key: formKey,
                child: Column(children: [
                  _showErrorMessage(),
                  _buildNameField(),
                  _buildTagField(),
                ]))));
  }

  _validateAndSubmit() async {
    setState(() {
      errorMessage = "";
    });

    if (validateAndSave()) {
      // todo: use a bloc to create the item
      Item item = Item(
        name: newName,
        id: rng.nextInt(100000),
        category: "test_category",
        startTime: currentDate,
        endTime: selectedDate,
        firebaseId: "",
        userId: "",
        utilities: [],
        images: images,
        notes: [],
      );

      _itemBloc.createItem(item).then((value) {
        widget.log.i('Created new item: $value');
        Scaffold.of(scaffoldCtx).showSnackBar(
            SnackBar(content: Text('Successfully created item!')));
        formKey.currentState.reset();
        Navigator.pop(context, null);
      }).catchError((e) {
        Scaffold.of(scaffoldCtx)
            .showSnackBar(SnackBar(content: Text('Failed to create item!')));
        widget.log.w("Failed to create item: $e");
      });
    } else {}

    //todo: setstate maybe here
  }

  Widget _showErrorMessage() {
    if (errorMessage != "") {
      return Text(
        errorMessage,
      );
    }
    return Container(width: 0, height: 0);
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _dateToReadable(DateTime date){
    String day = date.day.toString();
    String month = date.month.toString();
    return day + '.' + month;
  }

  String _differenceToDate(DateTime selected) {
    final now = DateTime.now();
    final difference = selected.difference(now).inDays;

    return difference.toString() + ' days';
  }

  Widget _buildDateSelector() {
    return Column(children: [
      Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Theme.of(context).primaryColor,
            child: GestureDetector(
              onTap: () => _showDatePicker(context),
              child: Container(
//                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                      _dateToReadable(DateTime.now()) +
                          ' - ' +
                          _dateToReadable(selectedDate)
                      + ' ,  ${_differenceToDate(selectedDate)}',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )),
      Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text("Choose timerange to track the items usefulness.",
            textAlign: TextAlign.center,
            style: new TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    ]);
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () => _validateAndSubmit(),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      child: Icon(Icons.save),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Container(
            decoration: BoxDecoration(
              gradient: getGradient(context),
            ),
            child: Stack(fit: StackFit.expand, children: [
              ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: ListView(
                  children: <Widget>[
                    _buildImageList(),
                    Padding(
                      padding: EdgeInsets.only(right: 16, left: 16, bottom: 8),
                      child: Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    _buildForm(),
                    _buildImageButton(),
                    _buildDateSelector(),
                  ],
                ),
              ),
            ]));
      }),
      floatingActionButton: Builder(
        builder: (context) {
          scaffoldCtx = context;
          return _buildFab();
        },
      ),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text("Add item"),
        actions: <Widget>[],
      ),
    );
  }
}

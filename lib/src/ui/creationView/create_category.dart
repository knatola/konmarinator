import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trailer_lender/src/bloc/itemBloc.dart';
import 'package:trailer_lender/src/models/item_category.dart';
import 'package:trailer_lender/src/service/logger.dart';

import '../../util.dart';

class CreateCategoryView extends StatefulWidget {

  CreateCategoryView();

  @override
  State<StatefulWidget> createState() {
    return CreateCategoryState();
  }
}

class CreateCategoryState extends State<CreateCategoryView> {
  final formKey = GlobalKey<FormState>();
  String categoryName;
  final _controller = TextEditingController();
  ItemBloc _itemBloc;
  final log = getLogger('CreateCategoryState');

  @override
  void initState() {
    super.initState();
    categoryName = "";
    _controller.addListener(() => setState(() { categoryName = _controller.text; }));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _itemBloc = ItemBlocProvider.of(context);
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _buildTextField() {
    return TextFormField(
        maxLines: 1,
        minLines: 1,
        keyboardType: TextInputType.text,
        obscureText: false,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
            fillColor: Colors.white,
            contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(32.0)),
            hintText: "Category",
            hintStyle: TextStyle(
              color: Colors.grey
            ),
            suffixIcon: GestureDetector(
              onTap: () => _createCategory(),
              child: Icon(
                Icons.add,
                color: categoryName == "" ? Colors.transparent : Colors.white,
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))),
            validator: (value) => value.isEmpty ? 'Category can\'t be empty' : null,
        controller: _controller,
        onSaved: (value) => categoryName = value,
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

  void _createCategory() {
    if (validateAndSave()) {
      if (categoryName != null && categoryName != "") {
        final id = Random().nextInt(1000);
        //todo: create category
        ItemCategory category = ItemCategory(name: categoryName, id: id, firebaseId: "");
        _itemBloc.createCategory(category).catchError((e) => log.e('Error creating category: $e'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      ),
      child: Form(
        key: formKey,
        child: Center(
          child: _buildTextField(),
        ),
      ),
    );
  }
}
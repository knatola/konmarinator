import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trailer_lender/src/bloc/itemBloc.dart';
import 'package:trailer_lender/src/models/item.dart';
import 'package:trailer_lender/src/models/item_category.dart';
import 'package:trailer_lender/src/models/item_utility.dart';
import 'package:trailer_lender/src/ui/common/custom_dialog.dart';
import 'package:trailer_lender/src/ui/creationView/addItemPage.dart';
import 'package:trailer_lender/src/ui/itemDetailScreen/itemDetailScreen.dart';

import '../../util.dart';

class KonMariView extends StatefulWidget {
  KonMariView({this.userId});

  final String userId;

  @override
  State<StatefulWidget> createState() {
    return KonMariViewState();
  }
}

class KonMariViewState extends State<KonMariView> {
  BuildContext scaffoldCtx;
  List<Item> items = [];
  ItemBloc _itemBloc;
  ItemCategory selectedCategory;
  bool searchVisible = false;
  double listTop = 60;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _itemBloc = ItemBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = ItemCategory(name: 'all', id: 1111111);
    searchVisible = false;
    listTop = 60;
  }


  Widget _buildItemsHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8),
              child: Text("Categories",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),),
            ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 4, right: 4),
          child:
              _buildCategoryStream(),
          ),
      ]),
    );
  }

  Widget _buildCategoryStream() {
    return StreamBuilder(
      stream: _itemBloc.categoryStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final categories = snapshot.data;
          if (categories.isNotEmpty) {
            return _buildCategories(categories);
          } else {
            return Text('Categories');
          }
        } else {
          return Text('Categories');
        }
      },
    );
  }

  Widget _buildCategories(List<ItemCategory> categories) {
    return Container(
      height: 36,
      child: Center(
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, position) {
              bool selected = selectedCategory.id == categories[position].id;
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[position];
                    });
                  },
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 8,
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.cyan
                            : Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Center(
                          child: Text(
                            categories[position].name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildListStream() {
    return Container(
        decoration: BoxDecoration(
          gradient: getGradient(context, 1),
        ),
        height: MediaQuery.of(context).size.height * 0.8,
        child: StreamBuilder(
            stream: _itemBloc.listStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              if (snapshot.hasData) {
                final items = snapshot.data;
                if (items.isNotEmpty) {
                  return _buildList(items);
                } else {
                  return _nothingHereText();
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return _nothingHereText();
              }
            }));
  }

  Widget _nothingHereText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Nothing here',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(32),
      elevation: 4,
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(32),
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: _buildSearchField(),
          )),
    );
  }

  Widget _buildSearchField() {
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
            onTap: () => {},
            child: Icon(
              Icons.search,
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0))),
      validator: (value) => value.isEmpty ? 'Category can\'t be empty' : null,
      onSaved: (value) => {},
    );
  }

  Widget _avatarImage(Item item) {
    if (item.images.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hero(
          tag: item.id,
          child: CircleAvatar(
              child: ClipOval(
            child: FadeInImage(
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              image: NetworkImage(item.images[0].imageUrl),
              placeholder: FileImage(File(item.images[0].localUrl)),
            ),
          )),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.error),
      );
    }
  }

  Widget _buildList(List<Item> itemList) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        itemCount: itemList.length,
        padding: const EdgeInsets.all(4.0),
        shrinkWrap: true,
        itemBuilder: (context, position) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              color: Colors.transparent,
              elevation: 5.0,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16.0)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: _avatarImage(itemList[position]),
                      title: Text(
                        itemList[position].name,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          ItemUtility.utilToString(
                            _itemBloc.getDaysUtility(
                                itemList[position], DateTime.now()),
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      contentPadding: EdgeInsets.only(bottom: 4),
                      onLongPress: () => _showDeleteDialog(itemList[position]),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ItemDetailScreen(itemList[position])));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "Delete",
        description: "Do you want to delete ${item.name}?",
        buttonText: "No",
        secondaryText: "Yes",
        callBack: () {
          _itemBloc.deleteItem(item);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _itemBloc.getUsersItems(widget.userId);
    _itemBloc.getCategories();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Center(
            child: Text("Today ${DateFormat.yMMMd().format(DateTime.now())}"),
          ),
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          scaffoldCtx = context;
          return FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => AddItemPage()));
                if (result != null) {
                  Scaffold.of(scaffoldCtx).showSnackBar(
                      SnackBar(content: Text('Successfully created item!')));
                }
              },
              child: Icon(Icons.add));
        }),
        body: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  elevation: 0,
                  expandedHeight: 160,
                  flexibleSpace: Material(
                    color: Theme.of(context).primaryColor,
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildItemsHeader(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildSearch(),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: _buildListStream()));
  }
}

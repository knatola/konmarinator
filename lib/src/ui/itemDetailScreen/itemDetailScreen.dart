import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:trailer_lender/src/bloc/itemBloc.dart';

import 'package:trailer_lender/src/models/item.dart';
import 'package:trailer_lender/src/models/note.dart';
import 'package:trailer_lender/src/service/logger.dart';
import 'package:trailer_lender/src/ui/common/utility_chart.dart';
import 'package:trailer_lender/src/ui/common/value_selector.dart';
import 'package:trailer_lender/src/ui/konMariList/add_note_view.dart';

import '../../util.dart';

class ItemDetailScreen extends StatefulWidget {
  ItemDetailScreen(this.item);

  final Item item;

  @override
  State<StatefulWidget> createState() {
    return ItemDetailState(item);
  }
}

class ItemDetailState extends State<ItemDetailScreen> {
  ItemDetailState(this.currentItem);
  final formKey = GlobalKey<FormState>();
  int selectedUtility = 3;
  int currentIndex = 0;
  Item currentItem;
  ItemBloc _itemBloc;
  final log = getLogger('ItemDetail');
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    selectedUtility = widget.item.getDaysUtility(DateTime.now()) + 1;
    currentIndex = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _itemBloc = ItemBlocProvider.of(context);

//    if (widget.item.utilities.isEmpty) {
//      final newUtil = ItemUtility(
//          id: Random().nextInt(1000),
//          date: DateTime.now(),
//          utility: 2,
//          itemId: widget.item.id);
//      widget.item.utilities.add(newUtil);
//      log.d('Created utility for today on item: ${widget.item}');
//      _itemBloc.createUtil(newUtil);
//    }
    streamSubscription?.cancel();
    streamSubscription = _itemBloc.singleStream.listen((item) {
      log.d('new item from stream : ${item.utilities.length}');
      setState(() {
        currentItem = item;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription?.cancel();
  }

  Widget _utilitySelector() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueSelector(currentItem, _onChangeValue),
          );
  }

  Widget _buildChart() {
    return SizedBox(
            height: 200,
            child: UtilityChart(
              currentItem.utilities,
              animate: true,
            )
    );
  }

  void _onChangeValue(int value) {
    final today = DateTime.now();
    var util = currentItem.utilities.firstWhere((util) =>
        (util.date.difference(today).inDays == 0 &&
            util.date.weekday == today.weekday));
    util.utility = value;
    _itemBloc.updateItem(currentItem);
  }

  Widget _buildImageContainer() {
    final images = currentItem.images;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.4,
      child: Padding(
        padding: const EdgeInsets.only(right: 0, left: 0),
        child: Hero(
          tag: currentItem.id,
          child: Swiper(
            itemCount: images.length,
            pagination: SwiperPagination(),
            control: SwiperControl(
              color: Colors.white,
            ),
            itemBuilder: (context, index) {
              return Card(
                color: Theme.of(context).primaryColor,
                semanticContainer: true,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(File(images[index].imageUrl), fit: BoxFit.fill,)
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAverage() {
    double average = currentItem.getAverageUtil();
    String avg = average.toStringAsFixed(2);
    String text = Item.getRecommendationText(average);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Average $avg', style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
            right: 16,
            left: 16,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildNoteButton() {
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).primaryColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
              Note note = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddNoteView(currentItem)));
              if (note != null)
                _itemBloc
                    .createNote(note)
                    .whenComplete(() => currentItem.notes.add(note));
            },
            child: Text("Add Note",
                textAlign: TextAlign.center,
                style: new TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ));
  }

  Widget _buildNoteField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Notes',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: currentItem.notes.length,
                itemBuilder: (context, position) {
                  final note = currentItem.notes[position];
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                    child: Material(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                      elevation: 5.0,
                      child: Container(
                        decoration: BoxDecoration(
//                          gradient: getGradient(context, 1),
                        color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ExpansionTile(
                          key: PageStorageKey(note),
                          title: Text(
                            dateToReadable(note.date),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  note.text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          _buildNoteButton(),
        ],
      ),
    );
  }

  Widget _buildUtility() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        elevation: 4,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: getGradient(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Value',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              _utilitySelector(),
              _buildChart(),
              _buildAverage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNote() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        elevation: 4,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
              gradient: getGradient(context, 1),
              borderRadius: BorderRadius.circular(16)),
          child: _buildNoteField(),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        elevation: 4,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: getGradient(context, 0),
              borderRadius: BorderRadius.circular(16)),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  currentItem.category,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
//      onSaved: (value) => noteText = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentItem.name),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: getGradient(context),
        ),
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            _buildImageContainer(),
            _buildInfo(),
            _buildUtility(),
            _buildNote(),
          ],
        ),
      ),
    );
  }
}

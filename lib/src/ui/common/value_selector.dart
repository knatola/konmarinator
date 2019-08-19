
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trailer_lender/src/models/item.dart';

class ValueSelector extends StatefulWidget {

  ValueSelector(this.item, this.callback);

  final void Function(int) callback;
  final Item item;

  @override
  State<StatefulWidget> createState() {
    return ValueSelectorState();
  }
}

class ValueSelectorState extends State<ValueSelector> {

  int selected = 2;
  List<int> values = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    selected = widget.item.getDaysUtility(DateTime.now());
    values = [1, 2, 3, 4, 5];
  }

  Widget _buildSelector(int number) {
    var color = Colors.black;
    var containerColor = Colors.transparent;
    var isSelected = (selected == number);
    if (isSelected) {
      color = Colors.white;
      containerColor = Theme.of(context).primaryColor;
    }

    return GestureDetector(
      onTap: () {
        widget.callback(number);
        setState(() {
          selected = number;
        });
      },
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 200),
        firstChild: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8.0, bottom: 8),
            child: Text(
              number.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
        ),
        secondChild: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8.0, bottom: 8),
            child: Text(
              number.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
        crossFadeState: isSelected? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: values.map((value) => _buildSelector(value)).toList(),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:trailer_lender/src/models/item_utility.dart';

class UtilityChart extends StatelessWidget {
  UtilityChart(this.data, {this.animate});

  factory UtilityChart.withTestData() {
    return UtilityChart(_createTestData(), animate: true,);
  }

  final bool animate;
  final List<ItemUtility> data;

  static List<ItemUtility> _createTestData() {
    return [
      ItemUtility(
          id: 0,
          itemId: 0,
          utility: 4,
          date: DateTime.now().subtract(Duration(days: 10))),
      ItemUtility(
          id: 0,
          itemId: 0,
          utility: 1,
          date: DateTime.now().subtract(Duration(days: 9))),
      ItemUtility(
          id: 0,
          itemId: 0,
          utility: 4,
          date: DateTime.now().subtract(Duration(days: 8))),
      ItemUtility(
          id: 0,
          itemId: 0,
          utility: 3,
          date: DateTime.now().subtract(Duration(days: 7))),
      ItemUtility(
          id: 0,
          itemId: 0,
          utility: 2,
          date: DateTime.now().subtract(Duration(days: 6))),
      ItemUtility(
          id: 0,
          itemId: 0,
          utility: 3,
          date: DateTime.now().subtract(Duration(days: 5))),
      ItemUtility(
          id: 0,
          itemId: 0,
          utility: 5,
          date: DateTime.now().subtract(Duration(days: 4))),
      ItemUtility(
          id: 0,
          itemId: 0,
          utility: 3,
          date: DateTime.now().subtract(Duration(days: 3))),
      ItemUtility(
          id: 0,
          itemId: 0,
          utility: 2,
          date: DateTime.now().subtract(Duration(days: 2))),
      ItemUtility(
          id: 0,
          itemId: 0,
          utility: 1,
          date: DateTime.now().subtract(Duration(days: 1))),
    ];
  }
  
  String _dateToLabel(DateTime date) {
    String day = date.day.toString();
    String month = date.month.toString();
    return '$day.$month';
  }

  Color _getColor(ItemUtility util) {
    var retVal;
    switch (util.utility) {
      case 1:
        retVal = Color(r: 0, g: 128, b: 128);
        break;
      case 2:
        retVal = Color(r: 0, g: 139, b: 139);
        break;
      case 3:
        retVal = Color(r: 0, g: 206, b: 209);
        break;
      case 4:
        retVal = Color(r: 72, g: 209, b: 204);
        break;
      case 5:
        retVal = Color(r: 0, g: 255, b: 255);
        break;
      default:
        retVal = Color(r: 0, g: 255, b: 255);
    }

    return retVal;
  }

  @override
  Widget build(BuildContext context) {
    List<Series<ItemUtility, String>> series = [
      Series(
        id: 'Utility',
        colorFn: (ItemUtility util, __) => _getColor(util),
        domainFn: (ItemUtility util, _) => _dateToLabel(util.date),
        measureFn: (ItemUtility util, _) => util.utility,
        data: data,
      ),
    ];

    print('Data length: ${data.length}');
    data.sort((a, b) => a.date.compareTo(b.date));
    if (data.length > 7) {
      return BarChart(
        series,
        animate: animate,
        primaryMeasureAxis: NumericAxisSpec(
            tickProviderSpec: StaticNumericTickProviderSpec([
              TickSpec(0),
              TickSpec(1),
              TickSpec(2),
              TickSpec(3),
              TickSpec(4),
              TickSpec(5)
            ])),
      );
    } else {
      print('returning with ordinalticks');
      return BarChart(
        series,
        animate: animate,
        domainAxis: AxisSpec<String>(
          showAxisLine: true,
            tickProviderSpec: StaticOrdinalTickProviderSpec([
              TickSpec(_dateToLabel(DateTime.now())),
              TickSpec(
                  _dateToLabel(DateTime.now().subtract(Duration(days: 1)))),
              TickSpec(
                  _dateToLabel(DateTime.now().subtract(Duration(days: 2)))),
              TickSpec(
                  _dateToLabel(DateTime.now().subtract(Duration(days: 3)))),
              TickSpec(
                  _dateToLabel(DateTime.now().subtract(Duration(days: 4)))),
              TickSpec(
                  _dateToLabel(DateTime.now().subtract(Duration(days: 4)))),
              TickSpec(
                  _dateToLabel(DateTime.now().subtract(Duration(days: 6)))),
            ]
            )),
        primaryMeasureAxis: NumericAxisSpec(
            tickProviderSpec: StaticNumericTickProviderSpec([
              TickSpec(0),
              TickSpec(1),
              TickSpec(2),
              TickSpec(3),
              TickSpec(4),
              TickSpec(5)
            ])),
      );
    }
  }
}

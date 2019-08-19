//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:trailer_lender/src/bloc/auth_bloc.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:trailer_lender/src/bloc/itemBloc.dart';
//import 'package:trailer_lender/src/bloc/user_bloc.dart';
//import 'package:trailer_lender/src/models/settings.dart';
//import 'package:trailer_lender/src/service/auth/baseAuthenticator.dart';
//import 'package:trailer_lender/src/service/database_helper.dart';
//import 'package:trailer_lender/src/service/items/firebase_item_service.dart';
//import 'package:trailer_lender/src/service/items/local_item_source.dart';
//import 'package:trailer_lender/src/service/logger.dart';
//import 'package:trailer_lender/src/ui/common/bottom_nav_bar.dart';
//import 'package:trailer_lender/src/ui/creationView/creationView.dart';
//import 'package:trailer_lender/src/ui/konMariList/konMariView.dart';
//import 'package:trailer_lender/src/ui/loginView/LoginView.dart';
//import 'package:trailer_lender/src/ui/creationView/addItemPage.dart';
//import 'package:trailer_lender/src/ui/mainList/mainListPage.dart';
//import 'package:trailer_lender/src/ui/profile/profile.dart';
//import 'package:trailer_lender/src/ui/settings/settings_view.dart';
//
//import '../util.dart';
//
/////Main Widget for the application.
//class Home extends StatefulWidget {
//  Home({
//    Key key,
//  }) : super(key: key);
//
//  final log = getLogger('Home');
//
//  @override
//  State<StatefulWidget> createState() {
//    return HomeState();
//  }
//}
//
//class HomeState extends State<Home> {
//  FlutterLocalNotificationsPlugin notificationsPlugin;
//
//  HomeState() {
//    _db = DatabaseHelper.instance;
//    repo = FirebaseItemService();
//    local = LocalItemSource(_db);
//  }
//
//  Settings settings;
//  AuthBloc _authBloc;
//  DatabaseHelper _db;
//  ItemBloc itemBloc;
//  UserBloc userBloc;
//  LocalItemSource local;
//  FirebaseItemService repo;
//  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
//  String userId = "";
//  int currentIndex = 0;
//  bool showAddItem = false;
//  final List<Widget> children = [];
//
//  @override
//  didChangeDependencies() {
//    super.didChangeDependencies();
//    _authBloc = AuthBlocProvider.of(context);
//    itemBloc = ItemBlocProvider.of(context);
//    userBloc = UserBlocProvider.of(context);
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    currentIndex = 1;
//    final initSettingsAndroid =
//        AndroidInitializationSettings("@mipmap/ic_launcher");
//    final initSettingsIos = IOSInitializationSettings();
//    final initSettings =
//        InitializationSettings(initSettingsAndroid, initSettingsIos);
//    notificationsPlugin = FlutterLocalNotificationsPlugin();
//    notificationsPlugin.initialize(initSettings,
//        onSelectNotification: selectNotification);
//    _showPeriodicNotification();
//  }
//
//  Future selectNotification(String payload) async {
//    showDialog(
//      context: context,
//      builder: (_) =>
//          AlertDialog(title: Text('Payload is:'), content: Text(payload)),
//    );
//  }
//
//  void changeSettings(Settings newSettings) {
//    setState(() {
//      settings = newSettings;
//    });
//  }
//
//  Future _showPeriodicNotification() async {
//    if (await _db.queryRowCount(DatabaseHelper.tableItem) < 0) {
//      return;
//    }
//    widget.log.d('Settings up periodic notification!');
//    var now = TimeOfDay.now();
//    var time = new Time(now.hour, now.minute + 2, 0);
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'repeatDailyAtTime channel id',
//        'repeatDailyAtTime channel name',
//        'repeatDailyAtTime description');
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    var platformChannelSpecifics = new NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await notificationsPlugin.showDailyAtTime(
//        0,
//        'show daily title',
//        'Daily notification shown at approximately ${(time.hour)}:${(time.minute)}:${(time.second)}',
//        time,
//        platformChannelSpecifics);
//  }
//
//  Future<bool> isNotificationOn() async {
//    List<PendingNotificationRequest> list =
//        await notificationsPlugin.pendingNotificationRequests();
//
//    widget.log.d('notifications: ${list.length}, $list');
//    if (list.length > 0) return true;
//    return false;
//  }
//
//  Future _showNotificationWithoutSound() async {
//    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//        'your channel id', 'your channel name', 'your channel description',
//        playSound: false, importance: Importance.Max, priority: Priority.High);
//    var iOSPlatformChannelSpecifics =
//        new IOSNotificationDetails(presentSound: false);
//    var platformChannelSpecifics = new NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await notificationsPlugin.show(
//      0,
//      'New Post',
//      'How to Show Notification in Flutter',
//      platformChannelSpecifics,
//      payload: 'No_Sound',
//    );
//  }
//
//  void onLoggedIn() {
//    _authBloc.getCurrentUser().then((user) async {
//      widget.log.d("onLoggedIn");
//      setState(() {
//        userId = user.uid.toString();
//        widget.log.d("userId: $userId");
//      });
//    });
//    setState(() {
//      authStatus = AuthStatus.LOGGED_IN;
//      currentIndex = 1;
//    });
//  }
//
//  void onSignedOut() {
//    widget.log.d("onSignedOut");
//    setState(() {
//      authStatus = AuthStatus.NOT_LOGGED_IN;
//      currentIndex = 1;
//      userId = "";
//    });
//  }
//
//  Widget buildWaitingScreen() {
//    return Scaffold(
//      body: Container(
//        alignment: Alignment.center,
//        child: CircularProgressIndicator(),
//      ),
//    );
//  }
//
//  void changeIndex(int newIndex) {
//    setState(() {
//      currentIndex = newIndex;
//    });
//  }
//
//  void initChildren() async {
//    if (children.isEmpty) {
//      children.add(MainListPage());
//      children.add(KonMariView(
//        userId: userId,
//      ));
//      children.add(Profile(currentUser: await userBloc.getCurrentUser()));
//    }
//  }
//
//  Widget _buildDrawer() {
//    return Drawer(
//      child: Container(
//        decoration: BoxDecoration(
//          gradient: getGradient(context),
//        ),
//        child: ListView(
//          padding: EdgeInsets.zero,
//          children: <Widget>[
//            DrawerHeader(
//              child: Center(
//                  child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                    Text(
//                      'Drawer Header',
//                    ),
//                    Icon(Icons.account_circle)
//                  ])),
//              decoration: BoxDecoration(
//                color: Theme.of(context).primaryColor,
//              ),
//            ),
//            ListTile(
//                title: Text('Item 1'),
//                onTap: () {
//                  _db.queryRowCount(DatabaseHelper.tableItem).then((count) {
//                    widget.log.d('Query Count for items: $count');
//                  });
//                  _db.queryRowCount(DatabaseHelper.tableImage).then((count) {
//                    widget.log.d('Query Count for images: $count');
//                  });
//                  _db.queryRowCount(DatabaseHelper.tableUtility).then((count) {
//                    widget.log.d('Query Count for util: $count');
//                  });
//                  widget.log.d('Checking notifications --> \n' +
//                      'is notifications:' +
//                      isNotificationOn().toString());
//                  itemBloc.getUsersItems(userId);
//                }),
//            ListTile(
//              title: Text('Item 2'),
//              onTap: () {
//                _showNotificationWithoutSound();
//                _showPeriodicNotification();
//              },
//            ),
//            ListTile(
//              leading: Icon(Icons.settings),
//              title: Text(
//                'Settings',
//                style: TextStyle(color: Colors.white),
//              ),
//              onTap: () {
//                Navigator.push(context, MaterialPageRoute(builder: (context) {
//                  return SettingsView();
//                }));
//              },
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  String _getTitle() {
//    if (currentIndex == 0) {
//      return 'Market';
//    } else if (currentIndex == 1) {
//      return "Today ${DateFormat.yMMMd().format(DateTime.now())}";
//    } else {
//      return "";
//    }
//  }
//
//  Widget getMainScreen() {
//    initChildren();
//    return Scaffold(
////      drawer: _buildDrawer(),
//      appBar: new AppBar(
//        elevation: 0.1,
//        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
//        actions: <Widget>[],
//        title: Center(
//          child: Text(
//            _getTitle(),
//          ),
//        ),
//      ),
//      bottomNavigationBar: BottomNavBar(
//        selected: currentIndex,
//        onPressed: changeIndex,
//      ),
//      body: getMainBody(),
//    );
//  }
//
//  Widget getMainBody() {
//    if (showAddItem) {
//      widget.log.d("userId: $userId");
//      return AddItemPage();
//    } else {
//      return children[currentIndex];
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    _authBloc.getCurrentUser().then((user) {
//      setState(() {
//        if (user != null) {
//          userId = user?.uid;
//        }
//        authStatus =
//            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
//      });
//    });
//    switch (authStatus) {
//      case AuthStatus.NOT_DETERMINED:
//        return buildWaitingScreen();
//        break;
//      case AuthStatus.NOT_LOGGED_IN:
//        return new LoginView(
//          authenticator: _authBloc.auth,
//          onSignedIn: onLoggedIn,
//        );
//        break;
//      case AuthStatus.LOGGED_IN:
//        if (userId.length > 0 && userId != null) {
//          return getMainScreen();
//        } else
//          return buildWaitingScreen();
//        break;
//      default:
//        return buildWaitingScreen();
//    }
//  }
//}
//
//enum AuthStatus {
//  NOT_DETERMINED,
//  NOT_LOGGED_IN,
//  LOGGED_IN,
//}

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:trailer_lender/src/service/image/baseImageService.dart';
import 'package:trailer_lender/src/service/image/local_image_service.dart';
import 'package:trailer_lender/src/service/logger.dart';

import '../../util.dart';

class AddImageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddImageState();
  }
}

class AddImageState extends State<AddImageScreen>
    with SingleTickerProviderStateMixin {
  final formKey = new GlobalKey<FormState>();
  String selectedImageUrl;
  String selectedImageName;
  String errorMessage;
  double bottomSelectorHeight;
  bool isLoading;
  bool selectorShown;
  final BaseImageService imageService = LocalImageService();
  final log = getLogger('AddImageScreen');
  AnimationController _controller;
  Animation<Color> animation;

  @override
  void initState() {
    isLoading = false;
    selectedImageUrl = "";
    selectedImageName = "";
    errorMessage = "";
    selectorShown = false;
    bottomSelectorHeight = 0.0;
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    animation = _getAnimation().animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _createImage() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    FocusScope.of(context).requestFocus(FocusNode());

    if (validateAndSave()) {
      // todo: use a bloc to create the item
      //todo : store also the local file url of the image
      if (selectedImageUrl != "" && selectedImageUrl != null) {
        String path = selectedImageUrl;
        String name = selectedImageName;
        final image = await imageService.createImage(path, name);
        Navigator.pop(context, image);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget _showProgressBar() {
    if (isLoading) {
      return Center(
          child: ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: _getAnimation().evaluate(
                              AlwaysStoppedAnimation(_controller.value))),
                      child: ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Loading",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: CircularProgressIndicator())
                            ],
                          )))))));
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  Animatable<Color> _getAnimation() {
    return TweenSequence<Color>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Color.fromRGBO(58, 66, 86, 1.0).withOpacity(0.5),
            end: Colors.transparent,
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Colors.transparent,
            end: Colors.blueGrey[300].withOpacity(0.5),
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Colors.blueGrey[300].withOpacity(0.5),
            end: Color.fromRGBO(58, 66, 86, 1.0).withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  void setImage(String url) {
    setState(() {
      selectedImageUrl = url;
    });
  }

  Widget _buildImageSelectBtn() {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).primaryColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              _showModalSheet();
            },
            child: Text("Select",
                textAlign: TextAlign.center,
                style: new TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ));
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Camera',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _openCamera(),
                  ),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_album,
                      color: Colors.white,
                    ),
                    title: new Text(
                      'Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _openGallery(),
                  ),
                ],
              ));
        });
  }

  Widget _buildPreview() {
    if (selectedImageUrl != "") {
      return Padding(
          padding: EdgeInsets.all(16.0),
          child: Material(
            color: Colors.transparent,
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: getGradient(context),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                  child: Image.file(
                File(selectedImageUrl),
                fit: BoxFit.fill,
              )),
            ),
          ));
    } else {
      return Padding(
          padding: EdgeInsets.all(16.0),
          child: Material(
            color: Colors.transparent,
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: getGradient(context),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ));
    }
  }

  void _openCamera() async {
    Navigator.pop(context);
    final file = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (file != null) setImage(file.uri.toFilePath());
    log.d('received file from camera: $file');
  }

  void _openGallery() async {
    Navigator.pop(context);
    final file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) setImage(file.uri.toFilePath());
    log.d('received file from camera: $file');
  }

  Widget _buildImageNameField() {
    return Padding(
        padding: EdgeInsets.only(top: 16, right: 16, left: 16),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          obscureText: false,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          decoration: InputDecoration(
              prefixIcon: new Icon(
                Icons.format_quote,
                color: Colors.white,
              ),
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(32.0)),
              hintText: "Name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
          onSaved: (value) => selectedImageName = value,
        ));
  }

  Widget _buildFab() {
    if (isLoading) {
      return Container(
        height: 0,
        width: 0,
      );
    } else {
      return FloatingActionButton(
        onPressed: () {
          _createImage();
        },
        child: Icon(Icons.done),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      );
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  Widget _buildForm() {
    return Center(
        child: Container(
            child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    _buildImageNameField(),
                  ],
                ))));
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
                    _buildPreview(),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
                        child: Divider()),
                    _buildForm(),
                    _buildImageSelectBtn(),
                  ],
                ),
              ),
              _showProgressBar(),
            ]));
      }),
      floatingActionButton: _buildFab(),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text("Select Image"),
        actions: <Widget>[],
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  FullScreenImage(this.close, this.url);

  final VoidCallback close;
  final String url;

  @override
  State<StatefulWidget> createState() {
    return FullScreenImageState();
  }
}

class FullScreenImageState extends State<FullScreenImage> {
  Widget _buildBody() {
    return Center(
        child: ClipRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: GestureDetector(
                    onTap: widget.close,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5)),
                        child: ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: Center(
                                child: Center(
                              child: Image.network(
                                widget.url,
                                fit: BoxFit.contain,
                              ),
                            ))))))));
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
